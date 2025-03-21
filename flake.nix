{
  description = "A very basic flake";

  inputs = {

    # Nix Packages collection
    # https://github.com/NixOS/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "git+https://github.com/NixOS/nixpkgs?ref=master&shallow=1";

    # Pure Nix flake utility functions
    # https://github.com/numtide/flake-utils
    flake-utils.url = "github:numtide/flake-utils";

    # Manage a user environment using Nix 
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Tools for managing NixOS

    # lollypops deployment tool
    # https://github.com/pinpox/lollypops
    lollypops = {
      url = "github:pinpox/lollypops";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    ### User repositories

    mayniklas = {
      url = "github:mayniklas/nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-utils.follows = "flake-utils";
      };
    };

    ### Applications

    # Adblocking lists for Unbound DNS servers running on NixOS
    # https://github.com/MayNiklas/nixos-adblock-unbound
    adblock-unbound = {
      url = "github:MayNiklas/nixos-adblock-unbound";
      inputs = {
        adblockStevenBlack.follows = "adblockStevenBlack";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Adblocking lists for DNS servers
    # input here, so it will get updated by nix flake update
    adblockStevenBlack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    # A discord bot for valorant communities
    # https://github.com/make-or-break/valorant-discord-bot
    discord-bot-valorant = {
      type = "github";
      owner = "make-or-break";
      repo = "valorant-discord-bot";
    };

  };

  outputs = { self, ... }@inputs:
    with inputs;
    {

      # Expose overlay to flake outputs, to allow using it from other flakes.
      # Flake inputs are passed to the overlay so that the packages defined in
      # it can use the sources pinned in flake.lock
      overlays.default = final: prev: (import ./overlays inputs) final prev;

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = {
        # modules
        ddcci = import ./modules/ddcci;
        hosts = import ./modules/hosts;
        kde = import ./modules/kde;
        networking = import ./modules/networking;
        nix-common = import ./modules/nix-common;
        thelounge = import ./modules/thelounge;
        home-manager = { pkgs, ... }: {
          imports = [ ./home-manager/home.nix ./home-manager/home-desktop.nix ];
        };

      };

      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (map
        (x: {
          name = x;
          value = nixpkgs.lib.nixosSystem {

            # Make inputs and the flake itself accessible as module parameters.
            # Technically, adding the inputs is redundant as they can be also
            # accessed with flake-self.inputs.X, but adding them individually
            # allows to only pass what is needed to each module.
            specialArgs = { flake-self = self; } // inputs;

            modules = [
              (./machines + "/${x}/configuration.nix")
              {
                imports =
                  builtins.attrValues self.nixosModules ++
                  builtins.attrValues mayniklas.nixosModules ++
                  [ lollypops.nixosModules.lollypops ];
              }
              {
                nixpkgs.overlays = [
                  self.overlays.default
                  mayniklas.overlays.mayniklas
                  (self: super: { })
                ];
              }
            ];
          };
        })
        (builtins.attrNames (builtins.readDir ./machines)));
    }

    //

    # flake-utils is used for this part to make each package available for each
    # system. This works as all packages are compatible with all architectures
    (flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ]) (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default mayniklas.overlays.mayniklas ];
          config = { allowUnfree = true; };
        };
      in
      rec {

        # Use nixpkgs-fmt for `nix fmt'
        formatter = pkgs.nixpkgs-fmt;

        packages = {

          woodpecker-pipeline = pkgs.callPackage ./pkgs/woodpecker-pipeline { inputs = inputs; flake-self = self; };

          build_outputs = pkgs.callPackage mayniklas.packages.${system}.build_outputs.override {
            inherit self;
            build_hosts = [ "desktop" "mobi" ];
            output_path = "~/.keep-nix-outputs-nonchris";
          };

        };

        apps = {

          lollypops = lollypops.apps.${pkgs.system}.default {
            configFlake = self;
          };

        };

      });
}

{
  description = "A very basic flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    mayniklas = {
      url = "github:mayniklas/nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-utils.follows = "flake-utils";
      };
    };

    # Adblocking lists for Unbound DNS servers running on NixOS
    # https://github.com/MayNiklas/nixos-adblock-unbound
    adblock-unbound = {
      url = "github:MayNiklas/nixos-adblock-unbound";
      inputs = {
        adblockStevenBlack.follows = "adblockStevenBlack";
        flake-utils.follows = "flake-utils";
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

    domain-check = {
      url = "github:nonchris/domain-check";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
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
        hosts = import ./modules/hosts;
        networking = import ./modules/networking;
        nix-common = import ./modules/nix-common;
        thelounge = import ./modules/thelounge;
        home-manager = { pkgs, nixpkgs-unstable, ... }: {
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

            system = "x86_64-linux";

            modules = [
              (./machines + "/${x}/configuration.nix")
              {
                imports = builtins.attrValues self.nixosModules
                ++ builtins.attrValues mayniklas.nixosModules;
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
      });
}

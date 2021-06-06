{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mayniklas.url = "github:mayniklas/nixos";
    mayniklas.inputs.nixpkgs.follows = "nixpkgs";
    mayniklas.inputs.home-manager.follows = "home-manager";

  };

  outputs = { self, ... }@inputs:
    with inputs;
    let
      # Function to create defult (common) system config options
      defFlakeSystem = systemArch: baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "${systemArch}";
          modules = [
            # Add home-manager option to all configs
            ({ ... }: {
              imports = builtins.attrValues self.nixosModules
                ++ builtins.attrValues mayniklas.nixosModules ++ [
                {
                  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                  # this setup with flakes, otherwise commands like `nix-shell
                  # -p pkgs.htop` will keep using an old version of nixpkgs.
                  # With this entry in $NIX_PATH it is possible (and
                  # recommended) to remove the `nixos` channel for both users
                  # and root e.g. `nix-channel --remove nixos`. `nix-channel
                  # --list` should be empty for all users afterwards
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                }
                baseCfg
                home-manager.nixosModules.home-manager
                # DONT set useGlobalPackages! It's not necessary in newer
                # home-manager versions and does not work with configs using
                # `nixpkgs.config`
                { home-manager.useUserPackages = true; }
              ];
              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
            })
          ];
        };

    in {

      nixosModules = {
        # modules
        hosts = import ./modules/hosts;
        networking = import ./modules/networking;
        nix-common = import ./modules/nix-common;
        thelounge = import ./modules/thelounge;
      };

      # Each subdirectory in ./machins is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (map (x: {
        name = x;
        value = defFlakeSystem "x86_64-linux" {
          imports = [
            (import (./machines + "/${x}/configuration.nix") { inherit self; })
          ];
        };
      }) (builtins.attrNames (builtins.readDir ./machines)));
    };
}

{
  description = "A very basic flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mayniklas.url = "github:mayniklas/nixos";
    mayniklas.inputs.nixpkgs.follows = "nixpkgs";
    mayniklas.inputs.home-manager.follows = "home-manager";

  };

  outputs = { self, ... }@inputs:
    with inputs; {

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
        home-manager = { pkgs, ... }: {
          imports = [ ./home-manager/home.nix ./home-manager/home-desktop.nix ];
        };

      };

      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (map (x: {
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
            { nixpkgs.overlays = [ self.overlays.default ]; }
          ];
        };
      }) (builtins.attrNames (builtins.readDir ./machines)));
    };
}

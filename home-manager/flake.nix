{
  description = "User configurations for nonchris";

  outputs = { self, nixpkgs }: {

    nixosModules = {

      # Desktop configuration, includes GUI
      desktop = { imports = [ ./home.nix ]; };

      # Serevr user configuration, only CLI
      server = { imports = [ ./home-server.nix ]; };

    };
  };
}

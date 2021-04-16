{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.common;
in {

  options.nonchris.common = { enable = mkEnableOption "activate nix-common"; };

  config = mkIf cfg.enable {

    nixpkgs = { config.allowUnfree = true; };

    nix = {

      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      binaryCachePublicKeys =
        [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
      binaryCaches =
        [ "https://cache.nixos.org" "https://cache.lounge.rocks?priority=50" ];
      trustedBinaryCaches =
        [ "https://cache.nixos.org" "https://cache.lounge.rocks" ];

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Users allowed to run nix
      allowedUsers = [ "root" ];
    };
  };
}

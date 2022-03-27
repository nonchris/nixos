{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.common;
in {

  options.nonchris.common = {
    enable = mkEnableOption "activate nix-common";
    disable-cache = mkEnableOption "not use binary-cache";
  };

  config = mkIf cfg.enable {

    nixpkgs = { config.allowUnfree = true; };

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      binaryCachePublicKeys = mkIf (cfg.disable-cache != true)
        [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
      binaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.nixos.org"
        "https://cache.lounge.rocks?priority=100"
        "https://s3.lounge.rocks/nix-cache?priority=50"
      ];
      trustedBinaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.nixos.org"
        "https://cache.lounge.rocks"
        "https://s3.lounge.rocks/nix-cache/"
      ];

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

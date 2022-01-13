{ lib, pkgs, config, inputs, ... }:
with lib;
let cfg = config.nonchris.common;
in {

  options.nonchris.common = { enable = mkEnableOption "activate nix-common"; };

  config = mkIf cfg.enable {

    environment.etc."nix/flake_inputs.prom" = {
      mode = "0555";
      text = ''
        # HELP flake_registry_last_modified Last modification date of flake input in unixtime
        # TYPE flake_input_last_modified gauge
        ${concatStringsSep "\n" (map (i:
          ''
            flake_input_last_modified{input="${i}",${
              concatStringsSep "," (mapAttrsToList (n: v: ''${n}="${v}"'')
                (filterAttrs (n: v: (builtins.typeOf v) == "string")
                  inputs."${i}"))
            }} ${toString inputs."${i}".lastModified}'') (attrNames inputs))}
      '';
    };

    nixpkgs = { config.allowUnfree = true; };

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      # binaryCachePublicKeys =
      #   [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
      # binaryCaches =
      #   [ "https://cache.nixos.org" "https://cache.lounge.rocks?priority=50" ];
      # trustedBinaryCaches =
      #   [ "https://cache.nixos.org" "https://cache.lounge.rocks" ];

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

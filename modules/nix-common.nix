{ config, pkgs, ... }: {

  nixpkgs = { config.allowUnfree = true; };

  nix = {

    binaryCachePublicKeys = [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
    binaryCaches = lib.mkForce [ "https://cache.nixos.org" "https://cache.lounge.rocks" ];
    trustedBinaryCaches = [ "https://cache.nixos.org" "https://cache.lounge.rocks" ];

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
}

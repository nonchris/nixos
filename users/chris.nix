{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:1kzr399yikf9jffyijrjxjvadh8r7pvinix3hwsq2hpdr0wr7pdp";
      })
    ];
  };
  nix.settings.allowed-users = [ "chris" ];
}

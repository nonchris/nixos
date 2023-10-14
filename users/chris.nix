{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:0y48k7fwpc3al61jca9pyc4v3hkwh5jfgdz6y4c7a90wd9x3lr0n";
      })
    ];
  };
  nix.settings.allowed-users = [ "chris" ];
}

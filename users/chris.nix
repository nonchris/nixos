{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:11fg32mprjlkgxp3iy4wr1flzxc44s6ls2vxjdbcznl14n462m1x";
      })
    ];
  };
  nix.settings.allowed-users = [ "chris" ];
}

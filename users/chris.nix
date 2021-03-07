{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles =
      [ (builtins.fetchurl { url = "https://github.com/nonchris.keys"; }) ];
  };
  nix.allowedUsers = [ "chris" ];
}

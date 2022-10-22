{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:1mdgn5cn46ywxv1q4420x5rwqpkmigidqjwimz78bj4ar7pkyhf0";
      })
    ];
  };
  nix.allowedUsers = [ "chris" ];
}

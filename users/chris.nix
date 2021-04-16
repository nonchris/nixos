{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
     (builtins.fetchurl {
       url = "https://github.com/nonchris.keys";
       sha256 = "sha256:15j5mb0v4di6gqbqxa1kl29g0g4zfbi2xmylpc6cagfk4z2jnk3w";
     })
   ];
  nix.allowedUsers = [ "chris" ];
}

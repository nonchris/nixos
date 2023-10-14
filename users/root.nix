{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:0y48k7fwpc3al61jca9pyc4v3hkwh5jfgdz6y4c7a90wd9x3lr0n";
      })
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "sha256:1xbv3i7qx9q3dpph5l2mbsd5dqg17d2z0bl1bm86f4pxm01dfvj1";
      })
    ];
  };
}

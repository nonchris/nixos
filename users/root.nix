{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:02352mgrlxm69gh742gpr1miciz7qj9ym6a3sg14bmbhz403ypfy";
      })
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "sha256:1xbv3i7qx9q3dpph5l2mbsd5dqg17d2z0bl1bm86f4pxm01dfvj1";
      })
    ];
  };
}

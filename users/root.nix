{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:1mdgn5cn46ywxv1q4420x5rwqpkmigidqjwimz78bj4ar7pkyhf0";
      })
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "sha256:1xbv3i7qx9q3dpph5l2mbsd5dqg17d2z0bl1bm86f4pxm01dfvj1";
      })
    ];
  };
}

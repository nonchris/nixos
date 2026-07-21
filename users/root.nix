{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:1kzr399yikf9jffyijrjxjvadh8r7pvinix3hwsq2hpdr0wr7pdp";
      })
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "sha256:1bnkwi3wmizj2xmz8djqjkfdwcz3c72jr583wiplayvmwnv74467";
      })
    ];
  };
}

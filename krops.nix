# Full example:
# https://tech.ingolf-wagner.de/nixos/krops/

let

  krops = (import <nixpkgs> { }).fetchgit {
    url = "https://cgit.krebsco.de/krops/";
    rev = "v1.17.0";
    sha256 = "150jlz0hlb3ngf9a1c9xgcwzz1zz8v2lfgnzw08l3ajlaaai8smd";
  };

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  source = name:
    lib.evalSource [{
      nixos-config.symlink =
        "machine-config/machines/${name}/configuration.nix";

      # Copy repository to /var/src
      machine-config.file = toString ./.;
    }];

  desktop = pkgs.krops.writeDeploy "desktop" {
    source = source "desktop";
    target = "root@nixos";
  };
  
  flap = pkgs.krops.writeDeploy "flap" {
    source = source "flap";
    target = "root@flap";
  };
  
  rick = pkgs.krops.writeDeploy "rick" {
    source = source "rick";
    target = "root@rick";
  };


in {

  # nix-build ./krops.nix -A desktop && ./result -j12
  desktop = desktop;

  # nix-build ./krops.nix -A flap && ./result -j4
  flap = flap;

  # nix-build ./krops.nix -A rick && ./result -j4
  rick = rick;

  # nix-build ./krops.nix -A all && ./result -j12
  all = pkgs.writeScript "deploy-all-servers"
    (lib.concatStringsSep "\n" [ desktop rick ]);

}

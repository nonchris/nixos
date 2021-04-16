{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-04-06
    url = "https://github.com/mayniklas/nixos";
    rev = "2710a8adf4e74f3d2e396aae5b3259612ae91766";
  };
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "master";
  };

in {
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    "${mayniklas}/modules/docker"
    "${mayniklas}/modules/locale"
    "${mayniklas}/modules/openssh"
    "${mayniklas}/modules/kvm-guest"
    "${mayniklas}/modules/options"
    "${mayniklas}/modules/zsh"

    # Modules
    ../../modules/nix-common

    # Containers
    ../../modules/containers/certificate_bot.nix
    ../../modules/containers/util-bot.nix

    # home-manager
    (import "${home-manager}/nixos")
  ];

  home-manager.users.chris = { imports = [ ../../home-manager/home-server.nix ]; };

  networking = { hostName = "mobi"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  nonchris = {
    common.enable = true;
  };

  mayniklas = {
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    kvm-guest.enable = true;
    zsh.enable = true;
  };
  
  users.users.root.openssh.authorizedKeys.keyFiles = [
    (builtins.fetchurl {
      url = "https://github.com/MayNiklas.keys";
      sha256 = "sha256:174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
    })
  ];

}

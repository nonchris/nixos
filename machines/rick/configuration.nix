{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-04-16
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
    "${mayniklas}/modules/options"
    "${mayniklas}/modules/vmware-guest"
    "${mayniklas}/modules/zsh"

    # Modules
    ../../modules/hosts
    ../../modules/networking
    ../../modules/nix-common
    ../../modules/thelounge

    # Containers
    #    ../../modules/containers/certificate_bot.nix

    # home-manager
    (import "${home-manager}/nixos")
  ];

  home-manager.users.chris = { imports = [ ../../home-manager/home-server.nix ]; };

  networking = { hostName = "rick"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  nonchris = {
    thelounge.enable = true;
    common.enable = true;
  };

  mayniklas = {
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    vmware-guest.enable = true;
    zsh.enable = true;
  };

}

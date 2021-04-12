{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-03-28
    url = "https://github.com/mayniklas/nixos";
    rev = "c0cda4acecaac8b4d335d6d82f92e7c39d3aa41b";
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
    "${mayniklas}/modules/docker.nix"
    "${mayniklas}/modules/locale.nix"
    "${mayniklas}/modules/openssh.nix"
    "${mayniklas}/modules/options.nix"
    "${mayniklas}/modules/vmware-guest.nix"
    "${mayniklas}/modules/zsh.nix"

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

  mainUser = "chris";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";

  home-manager.users.chris = { imports = [ ../../home-manager/home-server.nix ]; };

  networking = { hostName = "rick"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  nonchris = {
    thelounge.enable = true;
    common.enable = true;
  };

}

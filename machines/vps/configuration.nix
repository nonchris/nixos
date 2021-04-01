{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-04-01
    url = "https://github.com/mayniklas/nixos";
    rev = "d4fa719e8a3b7bc7d6e2ddde7b4c84e1a011becf";
  };
  home = builtins.fetchGit {
    url = "https://github.com/nonchris/nixos-home";
    ref = "main";
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
    "${mayniklas}/modules/kvm-guest.nix"
    "${mayniklas}/modules/options.nix"
    "${mayniklas}/modules/zsh.nix"

    # Modules
    ../../modules/nix-common.nix

    # Containers
    ../../modules/containers/certificate_bot.nix

    # home-manager
    (import "${home-manager}/nixos")
  ];

  mainUser = "chris";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";

  home-manager.users.chris = import "${home}/home-server.nix";

  networking = { hostName = "vps"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

}

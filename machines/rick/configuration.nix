{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-03-28
    url = "https://github.com/mayniklas/nixos";
    rev = "c0cda4acecaac8b4d335d6d82f92e7c39d3aa41b";
  };

in {
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    "${mayniklas}/modules/locale.nix"
    "${mayniklas}/modules/openssh.nix"
    "${mayniklas}/modules/options.nix"
    "${mayniklas}/modules/vmware-guest.nix"
    "${mayniklas}/modules/zsh.nix"

    # Modules
    ../../modules/hosts.nix
    ../../modules/networking.nix
    ../../modules/nix-common.nix
  ];
  
  mainUser = "chris";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";
  
  networking = { hostName = "rick"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

}

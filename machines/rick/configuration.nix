{ config, lib, pkgs, ... }:
let
  mayniklas = builtins.fetchGit {
    # Updated 2020-03-14
    url = "https://github.com/mayniklas/nixos";
    rev = "bc05167e9221088531f1b03978bd4fdb8a86cbee";
  };

in {
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    "${mayniklas}/modules/locale.nix"
    "${mayniklas}/modules/openssh.nix"
    "${mayniklas}/modules/zsh.nix"

    # Modules
    ../../modules/hosts.nix
    ../../modules/networking.nix
    ../../modules/nix-common.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  boot.growPartition = true;

  boot.loader.grub = {
    version = 2;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  virtualisation.vmware.guest.enable = true;
  
  networking = { hostName = "rick"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

}

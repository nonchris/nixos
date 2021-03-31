# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let
  mayniklas = builtins.fetchGit {
    # Updated 2020-03-14
    url = "https://github.com/mayniklas/nixos";
    rev = "bc05167e9221088531f1b03978bd4fdb8a86cbee";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    "${mayniklas}/modules/bluetooth.nix"
    "${mayniklas}/modules/docker.nix"
    "${mayniklas}/modules/grub-luks.nix"
    "${mayniklas}/modules/kde.nix"
    "${mayniklas}/modules/locale.nix"
    "${mayniklas}/modules/openssh.nix"
    "${mayniklas}/modules/options.nix"
    "${mayniklas}/modules/sound.nix"
    "${mayniklas}/modules/yubikey.nix"
    "${mayniklas}/modules/zsh.nix"

    # Modules
    ../../modules/hosts.nix
    ../../modules/networking.nix
    ../../modules/nix-common.nix
  ];

  mainUser = "chris";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";

  # Get UUID from blkid /dev/sda2
  mayniklas = {
    grub-luks = {
      enable = true;
      uuid = "6d09ef0e-d2ce-4c0a-845e-59dd32145d65";
    };
  };

  networking = { hostName = "flap"; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    ../../modules/bluetooth.nix
    ../../modules/docker.nix
    ../../modules/grub-luks.nix
    ../../modules/kde.nix
    ../../modules/locale.nix
    ../../modules/nix-common.nix
    ../../modules/nvidia.nix
    ../../modules/openssh.nix
    ../../modules/options.nix
    ../../modules/sound.nix
    ../../modules/yubikey.nix
    ../../modules/zsh.nix

    # Modules
    ../../modules/networking.nix
  ];

  mainUser = "chris";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";

  # Get UUID from blkid /dev/nvme0n1p2
  mayniklas = {
    grub-luks = {
      enable = true;
      uuid = "b99b7086-f4ab-4953-8966-e720abcd6aa2";
    };
  };

  networking = { hostName = "nixos"; };

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

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

    # Modules
    ../../modules/hosts
    ../../modules/networking

    # home-manager
    (import "${home-manager}/nixos")
  ];

  # Get UUID from blkid /dev/nvme0n1p2
  mayniklas = {
    var.mainUser = "chris";
    bluetooth.enable = true;
    docker.enable = true;
    grub-luks = {
      enable = true;
      uuid = "b99b7086-f4ab-4953-8966-e720abcd6aa2";
    };
    kde.enable = true;
    locale.enable = true;
    nvidia.enable = true;
    openssh.enable = true;
    sound.enable = true;
    yubikey.enable = true;
    zsh.enable = true;
  };

  networking = { hostName = "nixos"; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  nonchris = { common.enable = true; };

  home-manager.users.chris = { imports = [ ../../home-manager/home.nix ]; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

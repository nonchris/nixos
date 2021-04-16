# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ self, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules
    ../../modules/hosts
    ../../modules/networking

  ];

  # Get UUID from blkid /dev/sda2
  mayniklas = {
    var.mainUser = "chris";
    bluetooth.enable = true;
    docker.enable = true;
    grub-luks = {
      enable = true;
      uuid = "6d09ef0e-d2ce-4c0a-845e-59dd32145d65";
    };
    kde.enable = true;
    locale.enable = true;
    openssh.enable = true;
    sound.enable = true;
    yubikey.enable = true;
    zsh.enable = true;
  };

  networking = { hostName = "flap"; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [ bash-completion git nixfmt wget ];

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

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
    metrics = {
      node.enable = true;
      blackbox.enable = true;
      flake.enable = true;
    };
    nvidia.enable = true;
    openssh.enable = true;
    sound.enable = true;
    virtualisation.enable = true;
    yubikey.enable = true;
    zsh.enable = true;
  };

  networking = {
    hostName = "desktop";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  environment.systemPackages =
    with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
      bash-completion
      git
      nixfmt
      ncurses
      wget
    ];

  services.openssh.forwardX11 = true;

  nonchris = {
    common.enable = true;
    hosts.enable = true;
    networking.enable = true;
  };

  home-manager.users.chris = {
    imports = [
      ../../home-manager/home.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

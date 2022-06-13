# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, adblock-unbound, ... }:

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
      node = {
        enable = true;
        flake = true;
      };
    };
    nvidia.enable = true;
    openssh.enable = true;
    sound.enable = true;
    virtualisation.enable = true;
    yubikey.enable = true;
    zsh.enable = true;
  };

  # Unbound is a validating, recursive, and caching DNS resolver.
  # It won't use any noticable ressources.
  # By using a DNS server running on the same host, 
  # we gain a lot of performance compared to the old router!
  #
  # Unbound is really powerful and gives us a lot of control!
  # It's only accessable to localhost.
  # We use Cloudflare through HTTPS -> DNS sniffing / manipulation by the ISP won't be possible
  #
  services.unbound = {
    enable = true;
    settings = {
      server = {
        # Adblocking!
        # For reference: https://github.com/MayNiklas/nixos-adblock-unbound
        # List being used: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
        include = [ "\"${adblock-unbound.packages.${pkgs.system}.unbound-adblockStevenBlack}\"" ];
        interface = [ "127.0.0.1" ];
        access-control = [ "127.0.0.0/8 allow" ];
      };
      forward-zone = [{
        name = ".";
        forward-addr =
          [ "1.1.1.1@853#cloudflare-dns.com" "1.0.0.1@853#cloudflare-dns.com" ];
        forward-tls-upstream = "yes";
      }];
    };
  };

  networking = {
    hostName = "desktop";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  environment.systemPackages =
    with pkgs; [
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
    user.chris.home-manager.desktop = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

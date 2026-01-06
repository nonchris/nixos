{
  pkgs,
  lib,
  config,
  discord-bot-valorant,
  ...
}:

{

  # nix run .\#lollypops -- mobi
  lollypops.deployment = {
    # build on your computer and copy the closure via ssh
    local-evaluation = true;
    ssh = {
      user = "root";
      host = "202.61.248.243";
    };
  };

  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Containers
    ../../modules/containers/boulder-scraper.nix
    ../../modules/containers/certificate_bot.nix
    ../../modules/containers/discord-fury.nix
    ../../modules/containers/frinder.nix
    ../../modules/containers/mssr-role-bot.nix
    ../../modules/containers/discord-replacement-case.nix
    ../../modules/containers/sheriffs-bot.nix
    ../../modules/containers/verification-listener.nix
    ../../modules/containers/verification-listener-uni-bonn-connect.nix
    ../../modules/containers/verification-listener-vk.nix
    ../../modules/containers/verification-listener-intermedia.nix

    # A discord bot for valorant communities
    # https://github.com/make-or-break/valorant-discord-bot
    discord-bot-valorant.nixosModules.valorant-discord-bot
    discord-bot-valorant.nixosModules.valorant-match-history

  ];

  networking = {
    hostName = "mobi";
    interfaces."ens3" = {
      ipv6.addresses = [
        {
          address = "2a03:4000:54:d16::1";
          prefixLength = 64;
        }
      ];
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "wrapped.cyber-chris.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://localhost:13675";
          # nix-shell --packages apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'
          basicAuthFile = "/var/src/secrets/wrapped/basicauth.htpasswd";
        };
      };
    };
  };

  security.acme.defaults.email = "$git@chris-ge.de";
  security.acme.acceptTerms = true;

  environment.systemPackages = with pkgs; [
    bash-completion
    git
    htop
    nixfmt
    wget
  ];

  # nix flake lock --update-input discord-bot-valorant
  services = {
    valorant-discord-bot = {
      enable = true;
      dataDir = "/var/lib/valorant";
      envfile = "/var/src/secrets/valorant/envfile";
    };
    valorant-match-history = {
      enable = true;
      dataDir = "/var/lib/valorant";
    };
  };

  nonchris = {
    boulder-scraper.enable = true;
    common.enable = true;
    discord-fury = {
      enable = true;
      version = "2.1.3";
    };
    mssr-role-bot.enable = true;
    user.chris.home-manager.enable = true;
    verification-listener-vk.enable = true;
  };

  mayniklas = {
    cloud.netcup-x86 = {
      enable = true;
    };
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    user = {
      root.enable = true;
    };
    zsh.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "20.09";

}

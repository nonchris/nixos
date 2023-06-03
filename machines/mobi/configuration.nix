{ pkgs, lib, config, discord-bot-valorant, ... }:

{
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

  networking = { hostName = "mobi"; };

  environment.systemPackages =
    with pkgs; [
      bash-completion
      git
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

  system.stateVersion = "20.09";

}

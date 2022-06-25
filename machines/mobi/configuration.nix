{ self, ... }:

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
    ../../modules/containers/sheriffs-bot.nix
    ../../modules/containers/verification-listener.nix
    ../../modules/containers/verification-listener-uni-bonn-connect.nix
    ../../modules/containers/verification-listener-vk.nix

  ];

  networking = { hostName = "mobi"; };

  environment.systemPackages =
    with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
      bash-completion
      git
      nixfmt
      wget
    ];

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
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    kvm-guest.enable = true;
    user = {
      root.enable = true;
    };
    zsh.enable = true;
  };

  system.stateVersion = "20.09";

}

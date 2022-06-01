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
    user.chris.home-manager.enable = true;
    verification-listener-vk.enable = true;
  };

  mayniklas = {
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    kvm-guest.enable = true;
    zsh.enable = true;
  };

  users.users.root.openssh.authorizedKeys.keyFiles = [
    (builtins.fetchurl {
      url = "https://github.com/MayNiklas.keys";
      sha256 = "sha256:174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
    })
  ];

  system.stateVersion = "20.09";

}

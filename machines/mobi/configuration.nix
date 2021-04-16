{ config, lib, pkgs, ... }: {
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules
    ../../modules/hosts
    ../../modules/networking
    ../../modules/nix-common
    ../../modules/thelounge

    # Containers
    #    ../../modules/containers/certificate_bot.nix

    # home-manager
    (import "${home-manager}/nixos")
  ];

  home-manager.users.chris = {
    imports = [ ../../home-manager/home-server.nix ];
  };

  networking = { hostName = "rick"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  nonchris = {
    thelounge.enable = true;
    common.enable = true;
  };

  mayniklas = {
    var.mainUser = "chris";
    docker.enable = true;
    locale.enable = true;
    openssh.enable = true;
    vmware-guest.enable = true;
    zsh.enable = true;
  };

}

{ self, ... }:

{
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Containers
    #    ../../modules/containers/certificate_bot.nix

  ];

  home-manager.users.chris = {
    imports = [
      ../../home-manager/home-server.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  networking = { hostName = "rick"; };

  environment.systemPackages =
    with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
      bash-completion
      git
      nixfmt
      wget
    ];

  nonchris = {
    common.enable = true;
    hosts.enable = true;
    thelounge.enable = true;
    networking.enable = true;
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

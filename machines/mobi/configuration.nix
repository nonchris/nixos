{ self, ... }:

{
  imports = [

    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Containers
    ../../modules/containers/certificate_bot.nix
    ../../modules/containers/discord-fury.nix

  ];

  home-manager.users.chris = {
    imports = [ ../../home-manager/home-server.nix ];
  };

  networking = { hostName = "mobi"; };

  environment.systemPackages = with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [ bash-completion git nixfmt wget ];

  nonchris = {
    common.enable = true;
    discord-fury = {
      enable = true;
      version = "2.0.0";
    };
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

}

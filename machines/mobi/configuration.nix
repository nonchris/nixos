{ self, ... }:

{
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

  ];

  # home-manager.users.chris = {
  #   imports = [ ../../home-manager/home-server.nix ];
  # };

  networking = { hostName = "rick"; };

  environment.systemPackages = with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [ bash-completion git nixfmt wget ];

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

  users.users.root.openssh.authorizedKeys.keyFiles = [
     (builtins.fetchurl {
       url = "https://github.com/MayNiklas.keys";
       sha256 = "sha256:174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
     })
   ];

}

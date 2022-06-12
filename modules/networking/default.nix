{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.networking;
in {

  options.nonchris.networking = {
    enable = mkEnableOption "activate networking";
  };

  config = mkIf cfg.enable {

    networking = {
      # Define the DNS servers
      nameservers = [ "1.1.1.1" ];

      # Enable networkmanager
      networkmanager.enable = true;
    };
    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups =
      [ "networkmanager" ];

  };
}

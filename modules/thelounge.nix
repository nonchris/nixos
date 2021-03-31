{ config, pkgs, lib, ... }: {
  services = {
    thelounge = {
      enable = true;
      private = true;
      port = 9000;
      extraConfig = { theme = "morning"; };
    };
  };
  networking.firewall.allowedTCPPorts = [ 9000 ];
}

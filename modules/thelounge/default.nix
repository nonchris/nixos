{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.thelounge;
in {

  options.nonchris.thelounge = {
    enable = mkEnableOption "activate thelounge";
    theme = mkOption {
      type = types.str;
      default = "morning";
    };
    port = mkOption {
      type = types.int;
      default = 9000;
    };
  };

  config = mkIf cfg.enable {
    services = {
      thelounge = {
        enable = true;
        private = true;
        port = cfg.port;
        extraConfig = { theme = "${cfg.theme}"; };
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

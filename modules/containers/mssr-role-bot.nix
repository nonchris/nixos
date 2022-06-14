{ lib, config, pkgs, ... }:
with lib;
let cfg = config.nonchris.mssr-role-bot;
in {
  options.nonchris.mssr-role-bot = {
    enable = mkEnableOption "deploy mssr-role-bot";
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.mssr-role-bot = {
      autoStart = true;
      image = "discord-role-selection_role-selection";
      volumes = [ "/docker/discord-role-selection/data:/app/data:rw" ];
    };
  };
}

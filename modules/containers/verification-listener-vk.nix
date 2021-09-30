{ lib, config, pkgs, ... }:
with lib;
let cfg = config.nonchris.verification-listener-vk;
in {
  options.nonchris.verification-listener-vk = {
    enable = mkEnableOption "deploy verification listener";
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.verification-listener-vk = {
      autoStart = true;
      image = "nonchris/verification-listener";
      extraOptions = [ "--env-file=/docker/verification-listener-vk/envfile" ];
      volumes = [ "/docker/verification-listener-vk/data:/app/data:rw" ];
    };
  };
}

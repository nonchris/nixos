{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.verification-listener-intermedia = {
    autoStart = true;
    image = "nonchris/verification-listener";
    extraOptions = [ "--env-file=/docker/verification-listener-intermedia/envfile" ];
    volumes = [ "/docker/verification-listener-intermedia:/app/data:rw" ];
  };
}

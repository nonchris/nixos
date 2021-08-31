{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.verification-listener = {
    autoStart = true;
    image = "nonchris/verification-listener";
    extraOptions = [ "--env-file=/docker/verification-listener/envfile" ];
    volumes = [ "/docker/verification-listener:/app/data:rw" ];
  };
}

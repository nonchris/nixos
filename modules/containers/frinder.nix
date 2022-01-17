{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.frinder = {
    autoStart = true;
    image = "nonchris/frinder";
    extraOptions = [ "--env-file=/docker/frinder/envfile" "-t" ];
    volumes = [ "/docker/frinder/data:/app/data:rw" ];
  };
}

{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.welcome-dialogue = {
    autoStart = true;
    image = "/nonchris/welcome-dialogue";
    extraOptions = [ "--env-file=/docker/welcome-dialogue/envfile" ];
    volumes = [ "/docker/welcome-dialogue:/app/data:rw" ];
  };
}

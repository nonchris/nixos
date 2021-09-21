{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.sheriffs-bot = {
    autoStart = true;
    image = "nonchris/sheriffs-bot";
    extraOptions = [ "--env-file=/docker/sheriffs-bot/envfile" ];
    volumes = [ "/docker/sheriffs-bot:/app/data:rw" ];
  };
}

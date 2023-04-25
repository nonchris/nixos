{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.discord-replacement-case- = {
    autoStart = true;
    image = "nonchris/discord-replacement-case";
    extraOptions = [ "--env-file=/docker/discord-replacement-case/envfile" ];
    volumes = [ "/docker/discord-replacement-case/data:/app/data:rw" ];
  };
}

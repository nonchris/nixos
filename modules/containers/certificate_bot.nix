{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.certificate-bot = {
    autoStart = true;
    image = "mayniki/certificate-bot";
    extraOptions = [ "--env-file=/docker/certificate-bot/envfile" ];
    volumes = [ "/docker/certificate-bot/data:/app/data:rw" ];
  };
}

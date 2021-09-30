{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.verification-listener = {
    autoStart = true;
    image = "nonchris/verification-listener";
    extraOptions = [ "--env-file=/docker/verification-listener-vk/envfile" ];
    volumes = [ "/docker/verification-listener-vk:/app/data:rw" ];
  };
}

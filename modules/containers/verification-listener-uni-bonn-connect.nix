{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.verification-listener-uni-bonn-connect =
    {
      autoStart = true;
      image = "nonchris/verification-listener";
      extraOptions =
        [ "--env-file=/docker/verification-listener-uni-bonn-connect/envfile" ];
      volumes =
        [ "/docker/verification-listener-uni-bonn-connect:/app/data:rw" ];
    };
}

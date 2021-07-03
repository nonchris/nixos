{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.discord-fury;
in {

  options.nonchris.discord-fury = {
    enable = mkEnableOption "activate discord-fury";

    config = mkIf cfg.enable {
      virtualisation.oci-containers.containers.discord-fury_app = {
        autoStart = true;
        image = "nonchris/discord-fury:2.0.0";
        environment = {
          UID = "1000";
          GID = "1000";
        };
        extraOptions = [
          "--env-file=/docker/discord-fury/envfile"
          "--network=discord-fury-br"
        ];
        volumes = [ "/docker/discord-fury/data/app:/app/data" ];
      };
      virtualisation.oci-containers.containers.discord-fury_db = {
        autoStart = true;
        image = "postgres:13.3";
        extraOptions = [
          "--env-file=/docker/discord-fury/envfile"
          "--network=discord-fury-br"
        ];
        volumes =
          [ "/docker/discord-fury/data/postgress:/var/lib/postgresql/data" ];
      };
      systemd.services.init-discord-fury-network = {
        description = "Create the network bridge discord-fury-br";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";
        script =
          let dockercli = "${config.virtualisation.docker.package}/bin/docker";
          in ''
            # Put a true at the end to prevent getting non-zero return code, which will
            # crash the whole service.
            check=$(${dockercli} network ls | grep "discord-fury-br" || true)
            if [ -z "$check" ]; then
              ${dockercli} network create discord-fury-br
            else
              echo "discord-fury-br already exists in docker"
            fi
          '';
      };
    };
  };
}

{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.util-bot_app = {
    autoStart = true;
    image = "nonchris/util-bot";
    extraOptions =
      [ "--env-file=/docker/util-bot/envfile" "--network=util-bot-br" ];
  };
  virtualisation.oci-containers.containers.util-bot_db = {
    autoStart = true;
    image = "mysql:8";
    cmd = [ "--default-authentication-plugin=mysql_native_password" ];
    extraOptions =
      [ "--env-file=/docker/util-bot/envfile" "--network=util-bot-br" ];
    volumes = [ "/docker/util-bot/data/mysql:/var/lib/mysql" ];
  };
  systemd.services.init-util-bot-network = {
    description = "Create the network bridge util-bot-br for utilbot.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script =
      let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "util-bot-br" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create util-bot-br
        else
          echo "util-bot-br already exists in docker"
        fi
      '';
  };

}

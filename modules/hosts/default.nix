{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.hosts;
in {

  options.nonchris.hosts = { enable = mkEnableOption "activate hosts"; };

  config = mkIf cfg.enable {

    networking = {
      # Additional hosts to put in /etc/hosts
      extraHosts = ''
        #
        192.168.88.1 unifi
        192.168.88.17 rick
        192.168.5.15 vsphere

        # home
        192.168.88.1 unifi.home
        192.168.88.17 rick.home
        # local
        192.168.5.15 vsphere.local
        # external
        202.61.248.243 mobi  # currently pointing to vps aka mobi2
      '';
    };

  };
}
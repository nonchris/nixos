{ config, pkgs, lib, ... }: {

  networking = {
    # Additional hosts to put in /etc/hosts
    extraHosts = ''
      #
      192.168.88.1 unifi
      192.168.5.15 vsphere
      
      # home
      192.168.88.1 unifi.home

      # local
      192.168.5.15 vsphere.local
    '';
  };
}

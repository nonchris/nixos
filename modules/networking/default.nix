{ config, pkgs, lib, ... }: {

  networking = {
    # Define the DNS servers
    nameservers = [ "192.168.88.10" "192.168.88.1" "1.1.1.1" ];

    # Enable networkmanager
    networkmanager.enable = true;
  };
  users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups = [ "networkmanager" ];
}
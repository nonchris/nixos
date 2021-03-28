{ config, lib, pkgs, ... }: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  boot.growPartition = true;

  boot.loader.grub = {
    version = 2;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  virtualisation.vmware.guest.enable = true;

  programs.ssh.startAgent = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    startWhenNeeded = true;
    challengeResponseAuthentication = false;
  };

  users = {
    users.root = {
      password = "root";
      openssh.authorizedKeys.keyFiles =
        [ (builtins.fetchurl { url = "https://github.com/nonchris.keys"; }) ];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
}

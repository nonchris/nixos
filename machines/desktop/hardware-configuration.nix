# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bb6c26b8-476e-4f85-b0d0-3f211bc2ef10";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/77B6-F519";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/4fb10d7c-63e1-473d-924f-ae88f4f0d05b"; }];

  # set cpu frequency scaling_governor (schedutil reduces power consumption)
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # The option definition `hardware.video.hidpi.enable' no longer has any effect.
  # Consider manually configuring fonts.fontconfig according to personal preference.
}

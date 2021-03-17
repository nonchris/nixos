{ pkgs, lib, ... }:
with lib; {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    # Users
    ../../users/chris.nix
    ../../users/root.nix

    # Modules imported from MayNiklas
    ../../modules/locale.nix
    ../../modules/nix-common.nix
    ../../modules/openssh.nix
    ../../modules/zsh.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    programs.ssh.startAgent = false;

    environment.systemPackages = with pkgs; [
      bash-completion
      git
      nixfmt
      wget
      htop
    ];

  };
}

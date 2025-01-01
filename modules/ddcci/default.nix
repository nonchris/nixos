{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.ddcci;
in {

  options.nonchris.ddcci = {
    enable = mkEnableOption "enable ddcci";
    brightness_step = mkOption {
      type = types.int;
      default = 5;
      description = "how much to change brightness by relative to current brightness";
    };
  };

  config = mkIf cfg.enable {

    boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/ddccontrol.nix
    # services.ddccontrol.enable = true;

    environment.systemPackages = [ pkgs.i2c-tools ];

    home-manager.users.chris = {
      home.packages = [
        # (pkgs.writeShellScriptBin "lb" ''
        #   # lower brightness
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-8 -r 0x10 -W -${toString cfg.brightness_step}
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-9 -r 0x10 -W -${toString cfg.brightness_step}
        # '')
        # (pkgs.writeShellScriptBin "hb" ''
        #   # higher brightness
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-8 -r 0x10 -W ${toString cfg.brightness_step}
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-9 -r 0x10 -W ${toString cfg.brightness_step}
        # '')
        # (pkgs.writeShellScriptBin "sb" ''
        #   # set brightness
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-8 -r 0x10 -w $1
        #   ${pkgs.ddccontrol}/bin/ddccontrol dev:/dev/i2c-9 -r 0x10 -w $1
        # '')
      ];
    };

  };

}

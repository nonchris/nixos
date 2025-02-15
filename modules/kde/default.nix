{ pkgs, lib, config, ... }:
with lib;
let cfg = config.nonchris.kde;
in
{

  options.nonchris.kde = {
    enable = mkEnableOption "activate kde";
  };

  config = mkIf cfg.enable {

    services.desktopManager.plasma6.enable = false;
    services.xserver.desktopManager.plasma5.enable = true;

    services.displayManager.sddm.enable = true;

    services.xserver = {
      enable = true;
      layout = "de";
      xkbOptions = "eurosign:e";
    };

  };
}

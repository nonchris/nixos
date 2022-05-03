{ lib, config, pkgs, ... }:
with lib;
let cfg = config.nonchris.boulder-scraper;
in {
  options.nonchris.boulder-scraper = {
    enable = mkEnableOption "deploy boulder-scraper";
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.boulder-scraper = {
      autoStart = true;
      image = "nonchris/boulder-scraper";
      volumes = [ "/docker/boulder-scraper/data:/app/data:rw" ];
    };
  };
}

{ config, pkgs, lib, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles = {
      chris = {
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://github.com/nonchris";
          "devtools.theme" = "dark";
        };
      };
    };
  };
}

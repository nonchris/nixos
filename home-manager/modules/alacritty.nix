{ config, pkgs, lib, ... }:
let vars = import ./vars.nix;
in {
  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {

      scrolling.history = 10000;
      env.TERM = "xterm-256color";

      window.opacity = 0.9;
      window = {
        dimensions = {
          lines = 45;
          columns = 120;
        };
        padding = {
          x = 3;
          y = 3;
        };
      };
      cursor = { style = "Beam"; };
      colors = {
        primary = {
          background = "0x${vars.colors.base00}";
          foreground = "0x${vars.colors.base05}";
        };
        cursor = {
          text = "0x${vars.colors.base00}";
          cursor = "0x${vars.colors.base0D}";
        };
        normal = {
          black = "0x${vars.colors.base00}";
          red = "0x${vars.colors.base08}";
          green = "0x${vars.colors.base0B}";
          yellow = "0x${vars.colors.base0A}";
          blue = "0x${vars.colors.base0D}";
          magenta = "0x${vars.colors.base0E}";
          cyan = "0x${vars.colors.base0C}";
          white = "0x${vars.colors.base05}";
        };
        bright = {
          black = "0x${vars.colors.base03}";
          red = "0x${vars.colors.base09}";
          green = "0x${vars.colors.base01}";
          yellow = "0x${vars.colors.base02}";
          blue = "0x${vars.colors.base04}";
          magenta = "0x${vars.colors.base06}";
          cyan = "0x${vars.colors.base0F}";
          white = "0x${vars.colors.base07}";
        };
      };
    };
  };
}

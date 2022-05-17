{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.user.chris.home-manager;

in {

  options.nonchris.user.chris.home-manager = {
    enable = mkEnableOption "activate headless home-manager profile for chris";
  };

  config = mkIf cfg.enable {

    # DON'T set useGlobalPackages! It's not necessary in newer
    # home-manager versions and does not work with configs using
    # nixpkgs.config`
    home-manager.useUserPackages = true;

    home-manager.users.chris = {

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      programs.command-not-found.enable = true;
      home.username = "chris";
      home.homeDirectory = "/home/chris";

      # Allow "unfree" licenced packages
      nixpkgs.config = { allowUnfree = true; };

      # Install these packages for my user
      home.packages = with pkgs; [ htop iperf3 nmap unzip ];

      # Imports
      imports = [ ./modules/git.nix ./modules/zsh.nix ];

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "21.05";
    };
  };
}

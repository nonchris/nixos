{ config, pkgs, ... }:

let
  mayniklas = builtins.fetchGit {
    # Updated 2020-03-07
    url = "https://github.com/mayniklas/nixos-home";
    rev = "cb1517d09b0995d4c7bad8424e7baa56b68c31c4";
  };
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "chris";
  home.homeDirectory = "/home/chris";

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Imports
  imports = [
    # imports from MayNiklas
    "${mayniklas}/modules/chromium.nix"
    
    # imports
    ./modules/alacritty.nix
    ./modules/firefox.nix
    ./modules/git.nix
    ./modules/jetbrains.nix
    ./modules/vscode.nix
    ./modules/zsh.nix
  ];

  home.packages = with pkgs; [
    _1password-gui
    atom
    discord
    gcc
    htop
    hugo
    mpv
    nvtop
    obs-studio
    pstree
    python3
    ruby
    signal-desktop
    spotify
    sublime-merge
    sublime3
    tdesktop
    thunderbird
    unzip
    vim
    vlc
    whois
    youtube-dl
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}

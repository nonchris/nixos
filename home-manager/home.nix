{ config, pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "chris";
  home.homeDirectory = "/home/chris";

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Imports
  imports = [
    # imports
    ./modules/alacritty.nix
    ./modules/chromium.nix
    ./modules/firefox.nix
    ./modules/git.nix
    ./modules/jetbrains.nix
    ./modules/vscode.nix
    ./modules/zsh.nix
  ];

  home.packages = with pkgs; [
    _1password-gui
    ansible
    atom
    cargo
    discord
    dotnet-sdk_5
    gcc
    gccStdenv
    gradle_6
    gnuplot
    gparted
    htop
    hugo
    #    linuxPackages.v4l2loopback
    maven
    mono
    mpv
    nvtop
    obs-studio
    #    obs-v4l2sink
    omnisharp-roslyn
    okular
    postman
    pstree
    python3
    #    python38Packages.ipykernel
    ruby
    rustc
    signal-desktop
    spotify
    sublime-merge
    sublime3
    tdesktop
    texstudio
    texlive.combined.scheme-full
    thunderbird
    unzip
    vim
    vlc
    whois
    youtube-dl
    zip
    zoom-us
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

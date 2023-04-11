{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nonchris.user.chris.home-manager;

in
{

  options.nonchris.user.chris.home-manager = {
    desktop = mkEnableOption "activate desktop home-manager profile for chris";
  };

  config = mkIf cfg.desktop {

    nonchris.user.chris.home-manager.enable = true;

    home-manager.users.chris = {

      # Imports
      imports = [
        ./modules/alacritty.nix
        ./modules/chromium.nix
        ./modules/firefox.nix
        ./modules/jetbrains.nix
        ./modules/vscode.nix
      ];

      home.packages =
        let
          # https://github.com/NixOS/nixpkgs/pull/223988
          pkgs-postman = import
            (builtins.fetchTarball {
              url = "https://github.com/johnrichardrinehart/nixpkgs/archive/7fe340e404b82e7890686e2a14990c465d06e797.tar.gz";
              sha256 = "sha256:076hr2pp8sgdinvdjmd13m7757adxr0abfy8mf1a1w6406ilf92k";
            })
            {
              system = "${pkgs.system}";
              config.allowUnfree = true;
            };
        in
        with pkgs; [
          _1password-gui
          ansible
          cargo
          discord
          dotnet-sdk_5
          element-desktop
          gcc
          gccStdenv
          gradle_6
          gnuplot
          gparted
          htop
          hugo
          # linuxPackages.v4l2loopback
          maven
          mono
          mpv
          nvtop
          obs-studio
          # obs-v4l2sink
          omnisharp-roslyn
          okular
          pkgs-postman.postman
          pstree
          python3
          # python38Packages.ipykernel
          ruby
          rustc
          signal-desktop
          spotify
          staruml
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

          # mayniklas
          mayniklas.vs-fix
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
    };
  };
}

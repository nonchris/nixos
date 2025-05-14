{ lib, pkgs, config, flake-self, ... }:
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
        {
          nixpkgs.overlays = [
            flake-self.overlays.default
          ];
        }
      ];

      home.packages =
        with pkgs; [
          _1password-gui
          ansible
          asciinema
          cargo
          discord
          dnsutils
          # dotnet-sdk_5 # Dotnet SDK 5.0 is EOL, please use 6.0 (LTS) or 7.0 (Current)
          element-desktop
          gcc
          gccStdenv
          gimp
          glances
          gnuplot
          gparted
          h
          htop
          hugo
          # linuxPackages.v4l2loopback
          libreoffice
          maven
          mono
          mpv
          neo-cowsay
          nil
          nix-tree
          nmap
          nvtopPackages.nvidia
          obs-studio
          # obs-v4l2sink
          omnisharp-roslyn
          okular
          oneko
          postman
          pstree
          python3
          # python38Packages.ipykernel
          ruby
          rustc
          signal-desktop
          speedtest-cli
          spotify
          staruml
          sublime-merge
          sublime3
          tdesktop

          texlive.combined.scheme-full
          texstudio
          thunderbird
          tree
          unzip
          vim
          vlc
          whois
          youtube-tui
          yt-dlp
          zip
          zoom-us
        ]
        # packages from MayNiklas overlay
        # (https://github.com/MayNiklas/nixos/blob/main/overlays/mayniklas.nix)
        ++ (with pkgs.mayniklas; [
          preview-update
          set-performance
          vs-fix
        ]);

      programs.zsh.shellAliases = {
        sm = "${pkgs.sublime-merge}/bin/smerge .";
      };

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

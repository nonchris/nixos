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
          cargo
          discord
          # dotnet-sdk_5 # Dotnet SDK 5.0 is EOL, please use 6.0 (LTS) or 7.0 (Current)
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

          (import
            (builtins.fetchTarball {
              url = "https://github.com/nixos/nixpkgs/archive/7c9cc5a6e5d38010801741ac830a3f8fd667a7a0.tar.gz";
              sha256 = "sha256:1f7nsfz327habs623k5sviafxvvvsjnarsvz3m99qsrw88zdd929";
            })
            { system = "${pkgs.system}"; config = { allowUnfree = true; }; }).postman

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
          texlive.combined.scheme-full
          texstudio
          thunderbird
          unzip
          vim
          vlc
          whois
          youtube-dl
          zip
          zoom-us

          # mayniklas
          mayniklas.set-performance
          mayniklas.vs-fix
        ];

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

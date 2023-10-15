{ config, pkgs, lib, ... }: {

  programs.tmux = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    # autocd = true;
    dotDir = ".config/zsh";

    sessionVariables = { ZDOTDIR = "/home/chris/.config/zsh"; };

    initExtra = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      # revert last n commits
      grv() {
        ${pkgs.git}/bin/git reset --soft HEAD~$1
      }
      # get github url of current repository
      gh() {
        echo $(${pkgs.git}/bin/git config --get remote.origin.url | sed -e 's/\(.*\)git@\(.*\):[0-9\/]*/https:\/\/\2\//g')
      }

      venv() {
      # check if not in virtualenv
        if [ -z "$VIRTUAL_ENV" ]; then
            echo "Not in virtualenv..."
            # check if venv exists
            if [ ! -d venv ]; then
                # create virtualenv
                echo "Creating virtual environment..."
                ${pkgs.python3}/bin/python3 -m venv venv
            fi
            # activate virtualenv
            echo "Activating virtual environment..."
            source venv/bin/activate
        else
            echo "Already in virtualenv..."
        fi
      }
    '';

    shellAliases = rec {

      # git

      # git status
      gs = "${pkgs.git}/bin/git status";

      # clean up repository
      clean = "${pkgs.git}/bin/git clean -xdn";
      destroy = "${pkgs.git}/bin/git clean -xdf";

      # navigation
      cg = "cd ~/git/";
      cn = "cd ~/nixos/";
      wm = "cd /home/chris/git/watchman-ubo-work-prototype";

      # nix

      # switching within a flake repository
      frb = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --use-remote-sudo switch --flake";

      # always execute nixos-rebuild with sudo for switching
      nixos-rebuild = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --use-remote-sudo";

      # list syslinks into nix-store
      nix-list = "${pkgs.nix}/bin/nix-store --gc --print-roots";

      # Other
      lsblk = "${pkgs.util-linux}/bin/lsblk -o name,mountpoint,label,size,type,uuid";

    };

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = false;
      save = 15000;
      share = true;
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
    ];
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "agnoster";
    plugins = [ "sudo" "docker" ];
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
}

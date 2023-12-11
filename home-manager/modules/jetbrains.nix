{ config, pkgs, ... }: {

  home.packages = with pkgs.jetbrains; [
    jdk
    clion
    # rider
    # ruby-mine
    idea-ultimate
    pycharm-professional

    # see https://github.com/NixOS/nixpkgs/pull/201518
    # see https://github.com/not-matthias/dotfiles-nix/issues/23
    #
    # cd ~/.local/share/JetBrains/PyCharm2022.2/github-copilot-intellij/copilot-agent/bin
    # ln -s $(realpath $(which copilot-agent)) $(pwd)/copilot-agent-linux
    pkgs.github-copilot-intellij-agent
  ];

  programs.zsh.shellAliases = {
    pc = "${pkgs.jetbrains.pycharm-professional}/bin/pycharm-professional . 2> /dev/null 1> /dev/null &";
  };

}

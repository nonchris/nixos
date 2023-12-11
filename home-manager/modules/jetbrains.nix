{ config, pkgs, ... }: {

  home.packages = with pkgs.jetbrains; [
    # tmp fix - causes an collision:
    # error: collision between `/nix/store/i14lzxz4yy041hxl2amqdkqyk3hsr7xz-zsh-5.9-man/share/man' and dangling symlink `/nix/store/p9yab7i19wvcaz4hyfx53315bzb3iahm-jetbrains-jdk-jcef-17.0.8-b1000.8/share/man'
    # jdk

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

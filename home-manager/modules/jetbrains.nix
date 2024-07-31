{ config, pkgs, ... }:
let
  nonchris-jetbrains-nixpkgs = (import
    (builtins.fetchTarball {
      url = "https://github.com/nonchris/nixpkgs/archive/c16900e39943577afbae120c6df5bf0f49878ddb.tar.gz";
      sha256 = "sha256:0x73sip0ac5v3iwkdincnkwdlm9f5rca2gn0s3c786fvqlfbp8i8";
    })
    { system = "${pkgs.system}"; config = { allowUnfree = true; }; });
in
{

  home.packages = with pkgs.jetbrains; [
    jdk

    clion
    gateway
    # rider
    # ruby-mine
    idea-ultimate
    nonchris-jetbrains-nixpkgs.jetbrains.pycharm-professional

    # see https://github.com/NixOS/nixpkgs/pull/201518
    # see https://github.com/not-matthias/dotfiles-nix/issues/23
    #
    # cd ~/.local/share/JetBrains/PyCharm2022.2/github-copilot-intellij/copilot-agent/bin
    # ln -s $(realpath $(which copilot-agent)) $(pwd)/copilot-agent-linux
    nonchris-jetbrains-nixpkgs.github-copilot-intellij-agent
  ];

  programs.zsh.shellAliases = {
    pc = "${pkgs.jetbrains.pycharm-professional}/bin/pycharm-professional . 2> /dev/null 1> /dev/null &";
    cl = "${pkgs.jetbrains.clion}/bin/clion . 2> /dev/null 1> /dev/null &";
    ij = "${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate . 2> /dev/null 1> /dev/null &";
    gw = "${pkgs.jetbrains.gateway}/bin/gateway 2> /dev/null 1> /dev/null &";
  };

}

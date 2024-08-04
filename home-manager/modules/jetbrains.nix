{ config, pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        pycharm-professional = (prev.jetbrains.plugins.addPlugins prev.jetbrains.pycharm-professional [ "github-copilot" ]);
      };
    })
  ];

  home.packages = with pkgs.jetbrains; [
    jdk

    clion
    gateway
    # rider
    # ruby-mine
    idea-ultimate
    pycharm-professional
  ];

  programs.zsh.shellAliases = {
    pc = "${pkgs.jetbrains.pycharm-professional}/bin/pycharm-professional . 2> /dev/null 1> /dev/null &";
    cl = "${pkgs.jetbrains.clion}/bin/clion . 2> /dev/null 1> /dev/null &";
    ij = "${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate . 2> /dev/null 1> /dev/null &";
    gw = "${pkgs.jetbrains.gateway}/bin/gateway 2> /dev/null 1> /dev/null &";
  };

}

{ config, pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        pycharm-professional = (import (builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/2ff53fe64443980e139eaa286017f53f88336dd0.tar.gz"; sha256 = "sha256:0ms5nbr2vmvhbr531bxvyi10nz9iwh5cry12pl416gyvf0mxixpv"; }
          prev.jetbrains.plugins.addPlugins
          prev.jetbrains.pycharm-professional [ "github-copilot" ]));
        gateway = (import (builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/47c1824c261a343a6acca36d168a0a86f0e66292.tar.gz"; sha256 = "sha256:0wwsc4ywn9xp9y2pkbxq3kkmhm5gliwmh308bq4gvc7w1mds19mn"; })
          {
            config.allowUnfree = true;
            system = pkgs.system;
          }).jetbrains.gateway;
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

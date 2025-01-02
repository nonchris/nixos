{ config, pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        pycharm-professional = (prev.jetbrains.plugins.addPlugins prev.jetbrains.pycharm-professional [ "github-copilot" ]);
        gateway = (import
          (builtins.fetchGit {
            name = "my-old-jetbrains-revision";
            url = "https://github.com/NixOS/nixpkgs/";
            ref = "refs/heads/nixos-unstable";
            rev = "47c1824c261a343a6acca36d168a0a86f0e66292";
          })
          { }).pkgs.jetbrains.gateway;
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

{ config, pkgs, ... }:
{
  home.packages = with pkgs.jetbrains; [
    jdk
    clion
    ruby-mine
    idea-ultimate
    pycharm-professional
  ];
}

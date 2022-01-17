{ config, pkgs, ... }: {
  home.packages = with pkgs.jetbrains; [
    jdk
    clion
#    rider
#    ruby-mine
    idea-ultimate
    pycharm-professional
  ];
}

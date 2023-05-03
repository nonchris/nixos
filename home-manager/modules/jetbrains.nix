{ config, pkgs, ... }: {
  home.packages = with pkgs.jetbrains; [
    jdk
    clion
    # rider
    # ruby-mine
    idea-ultimate
    pycharm-professional

    # # I want to try this out in the future.
    # # it might (!) do something...
    # (pycharm-professional.override {
    #   python3 = (pkgs.unstable.python3.withPackages
    #     (p: with p; [
    #       pip
    #       setuptools
    #       fastapi
    #       matplotlib
    #       multipart
    #       numpy
    #       pandas
    #       requests
    #       scipy
    #       uvicorn
    #     ]));
    # })

    # see https://github.com/NixOS/nixpkgs/pull/201518
    # see https://github.com/not-matthias/dotfiles-nix/issues/23
    (pkgs.callPackage ./copilot-agent.nix { })
  ];
}

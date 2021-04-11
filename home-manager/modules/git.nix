{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      ignores = [ "tags" "*.swp" ];

      extraConfig = { pull.rebase = false; };

      userEmail = "git@chris-ge.de";
      userName = "nonchris";
    };
  };
}
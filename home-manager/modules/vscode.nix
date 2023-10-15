{ config, pkgs, lib, ... }: {


  

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
        # privacy
        "telemetry.telemetryLevel" = "off";

        # style
        "terminal.integrated.fontFamily" = "source code pro";
        "workbench.colorTheme" = "GitHub Dark Default";

        # jnoortheen.nix-ide
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "${pkgs.nil}/bin/nil";
          "serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
              };
            };
          };
        };
    };

    extensions = with pkgs.vscode-extensions; [
      # lextudio.restructuredtext  # not existing
      # ms-dotnettools.csharp
      # github.copilot
      github.github-vscode-theme
      github.vscode-github-actions
      github.vscode-pull-request-github
      ms-python.python
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      # vscodevim.vim
      jnoortheen.nix-ide
      james-yu.latex-workshop
      # spmeesseman.vscode-taskexplorer  # not existing
      yzhang.markdown-all-in-one
      zhuangtongfa.material-theme
    ];
  };

}

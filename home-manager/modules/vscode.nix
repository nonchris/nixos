{ config, pkgs, lib, ... }: {

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      # annoying
      "explorer.autoReveal" = false;

      # privacy
      "telemetry.telemetryLevel" = "off";
      "redhat.telemetry.enabled" = false;

      # style
      "terminal.integrated.fontFamily" = "source code pro";
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.tree.indent" = 16;

      # Copilot
      "github.copilot.enable" = {
        # enabled
        "*" = true;
        "markdown" = true;
        # disabled
        "plaintext" = false;
        "scminput" = false;
      };

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

      # LaTeX Workshop Settings
      "latex-workshop.latex.recipes" = [{
        "name" = "lualatex->biber->lualatex";
        "tools" = [ "lualatex" "biber" "lualatex" ];
      }];
        
      "latex-workshop.latex.tools" = [
        {
          "name" = "lualatex";
          "command" = "lualatex";
          "args" = [ "-synctex=1" "-interaction=nonstopmode" "-file-line-error" "-pdf" "%DOC%" ];
        }
      ];
    };

    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.github-vscode-theme
      github.vscode-github-actions
      github.vscode-pull-request-github
      ms-python.python
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      redhat.java
      jnoortheen.nix-ide
      james-yu.latex-workshop
      yzhang.markdown-all-in-one
      zhuangtongfa.material-theme
      dracula-theme.theme-dracula
    ];
  };

}

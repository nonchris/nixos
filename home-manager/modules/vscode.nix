{ config, pkgs, lib, ... }: {

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-python.python
      ms-vscode.cpptools
#      ms-vsliveshare.vsliveshare
      vscodevim.vim
      james-yu.latex-workshop
    ];
  };
}

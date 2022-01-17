{ config, pkgs, lib, ... }: {

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      # bbenoist.Nix
      brettm12345.nixfmt-vscode
      # lextudio.restructuredtext  # not existing
      # ms-dotnettools.csharp
      ms-python.python
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      #      vscodevim.vim
      james-yu.latex-workshop
      # spmeesseman.vscode-taskexplorer  # not existing
      zhuangtongfa.material-theme
    ];
  };
}

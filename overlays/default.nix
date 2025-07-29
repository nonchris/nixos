inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super:
let
  system = super.system;
  pkgs-master = (import inputs.nixpkgs-master {
    inherit system;
    config = { allowUnfree = true; };
  });
  prismlauncher-pkgs = (
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/28ace32529a63842e4f8103e4f9b24960cf6c23a.tar.gz";
        sha256 = "sha256:1zphnsa5dhwgi4dsqza15cjvpi7kksidfmjkjymjninqpv04wgfc";
      })
      {
        inherit system;
      });
in
{
  # packages from unstable

  # Custom packages. Will be made available on all machines and used where
  # needed.

  # custom packages

  discord = pkgs-master.discord;
  prismlauncher = prismlauncher-pkgs.prismlauncher;

}

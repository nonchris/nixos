inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super:
{
  # packages from unstable

  # Custom packages. Will be made available on all machines and used where
  # needed.

  # custom packages

}

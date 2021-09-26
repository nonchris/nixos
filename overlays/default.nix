self: super: {
  # override with newer version from nixpkgs-unstable (home-manager related)
  discord = self.unstable.discord;
  signal-desktop = self.unstable.signal-desktop;
  spotify = self.unstable.spotify;
  zoom-us = self.unstable.zoom-us;
}

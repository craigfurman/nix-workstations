{
  flake,
  overlay,
  system,
  ...
}:
{
  nix.settings.experimental-features = "nix-command flakes";

  system.configurationRevision = flake.rev or flake.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.hostPlatform = system;

  nixpkgs.overlays = [ overlay ];

  imports = [
    ./autokbisw.nix
    ./settings.nix
  ];
}

{
  flake,
  overlay,
  system,
  ...
}:
{
  imports = [
    ./apps.nix
    ./manage-other-machines.nix
    ./nix.nix
    ./settings.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
    overlays = [ overlay ];
  };

  system.primaryUser = "craig";

  system.configurationRevision = flake.rev or flake.dirtyRev or null;
  system.stateVersion = 5;
}

{
  config,
  flake,
  overlay,
  system,
  ...
}:
{
  imports = [
    ../nixos/manage-other-machines.nix
    ./apps.nix
    ./nix.nix
    ./settings.nix
  ];

  manageOtherMachines = {
    enable = true;
    flakePath = "/etc/nix-darwin";
    user = config.system.primaryUser;
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
    overlays = [ overlay ];
  };

  system.primaryUser = "craig";

  system.configurationRevision = flake.rev or flake.dirtyRev or null;
  system.stateVersion = 5;
}

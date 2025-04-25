{
  flake,
  overlay,
  system,
  ...
}:
{
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "craig" ];
  };

  system.configurationRevision = flake.rev or flake.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.hostPlatform = system;

  nixpkgs.overlays = [ overlay ];

  imports = [
    ./apps.nix
    ./autokbisw.nix
    ./manage-other-machines.nix
    ./settings.nix
  ];

  nix = {
    # Clean up old darwin generations. I believe this will run as root. HM
    # defines its own GC.
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    # For building linux packages in a qemu VM. I don't want to leave this on
    # all the time, so it is disabled usually.
    linux-builder = {
      enable = false;
    };
  };
}

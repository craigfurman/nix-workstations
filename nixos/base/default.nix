{ overlay, pkgs, ... }:
{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ overlay ];
  };
}

{ overlay, ... }:
{
  imports = [
    ../ssh-server.nix
  ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "craig" ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ overlay ];
  };
}

{ config, overlay, ... }:
{
  imports = [
    ./ssh.nix
  ];

  environment.etc.nixos.source = "${config.users.users.craig.home}/.config/nixos";

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

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

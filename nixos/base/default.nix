{ config, overlay, ... }:
{
  imports = [
    ../ssh-server.nix
  ];

  environment.etc.nixos.source = "${config.users.users.craig.home}/.config/nixos";

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

  security.pam.sshAgentAuth.enable = true;
}

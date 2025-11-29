{ config, ... }:
{
  environment.etc.nix-darwin.source = "${
    config.users.users.${config.system.primaryUser}.home
  }/.config/nix-darwin";

  nix = {
    # Clean up old darwin generations. I believe this will run as root. HM
    # defines its own GC.
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;

    # For building linux packages in a qemu VM. I don't want to leave this on
    # all the time, so it is disabled usually.
    linux-builder = {
      enable = false;
    };

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ config.system.primaryUser ];
    };
  };
}

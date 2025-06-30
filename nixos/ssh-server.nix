{ config, lib, ... }:
{
  options.services.custom.ssh-server = {
    enable = lib.mkEnableOption "ssh-server";

    authorizedKeys =
      with lib;
      mkOption {
        type = types.listOf types.lines;
      };
  };

  config = lib.mkIf config.services.custom.ssh-server.enable {
    users.users.craig = {
      openssh.authorizedKeys.keys = config.services.custom.ssh-server.authorizedKeys;
    };

    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}

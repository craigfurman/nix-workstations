{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.bluesnooze = {
    enable = lib.mkEnableOption "enable Bluesnooze";
    hideIcon = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config =
    let
      cfg = config.services.bluesnooze;
    in
    lib.mkIf cfg.enable {
      launchd.user.agents.blueznooze = {
        command = "${pkgs.bluesnooze}/Applications/Bluesnooze.app/Contents/MacOS/Bluesnooze";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/bluesnooze.log";
          StandardErrorPath = "/tmp/bluesnooze.log";
        };
      };

      system.defaults.CustomUserPreferences = {
        "com.oliverpeate.Bluesnooze" = {
          hideIcon = cfg.hideIcon;
        };
      };
    };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.autokbisw.enable = lib.mkEnableOption "enable autokbisw";

  config = {
    launchd.agents.autokbisw = {
      enable = config.services.autokbisw.enable;
      config = {
        Program = "${pkgs.autokbisw}/bin/autokbisw";
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/autokbisw.log";
        StandardErrorPath = "/tmp/autokbisw.log";
      };
    };
  };
}

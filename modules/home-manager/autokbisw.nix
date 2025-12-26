{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.autokbisw.enable = lib.mkEnableOption "enable autokbisw";

  config = {
    # Currently, giving autokbisw the ability to monitor keyboard input is a
    # manual step. I don't think nix-darwin supports this yet.
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

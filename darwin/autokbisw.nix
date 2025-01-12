{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.autokbisw ];

  launchd.user.agents.autokbisw = {
    command = "${pkgs.autokbisw}/bin/autokbisw";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/autokbisw.log";
      StandardErrorPath = "/tmp/autokbisw.log";
    };
  };
}

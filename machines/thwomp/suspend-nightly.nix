{
  networking.interfaces.enp2s0.wakeOnLan.enable = true;

  systemd.timers.suspend-system = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      Unit = "systemd-suspend.service";
      Persistent = false;
    };
  };
}

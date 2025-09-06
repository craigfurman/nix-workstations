{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    let
      retroarchWithCores = retroarch.withCores (
        cores: with cores; [
          bsnes
          citra
          dolphin
          gambatte
          mupen64plus
        ]
      );
    in
    [
      azahar
      dualsensectl
      dolphin-emu
      retroarchWithCores
      steam-rom-manager
    ];

  # Can boot into this, but I choose not to for now. I'm not actually 100% sure
  # programs.steam.gamescopeSession is doing anything.
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    let
      retroarchWithCores = retroarch.withCores (
        cores: with cores; [
          bsnes
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

  # individual steam games can be made to use this
  # TODO gamemode doesn't appear to work
  programs.gamemode.enable = false;
  users.users.craig.extraGroups = lib.optional config.programs.gamemode.enable "gamemode";

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

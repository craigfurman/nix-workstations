{
  craigLib,
  pkgs,
  secrets,
  ...
}:
{
  home.file.".config/backup/.envrc".text = craigLib.mkEnvrc secrets.backup;
  home.packages = [ pkgs.restic ];

  launchd.agents.restic-backup = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "source ~/.config/backup/.envrc && ${pkgs.restic}/bin/restic --cleanup-cache backup --exclude-file ${./excludes.txt} --one-file-system --exclude-caches --exclude-if-present .backupignore ~"
      ];

      StartCalendarInterval = [
        {
          Hour = 11;
          Minute = 0;
        }
      ];

      StandardOutPath = "/tmp/restic.log";
      StandardErrorPath = "/tmp/restic.log";
    };
  };
}

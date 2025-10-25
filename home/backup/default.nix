{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  restic = pkgs.writeShellApplication {
    name = "restic";
    runtimeInputs = [ pkgs.restic ];
    text = ''
      RESTIC_REPOSITORY=${secrets.backup.RESTIC_REPOSITORY} \
        RESTIC_PASSWORD=${secrets.backup.RESTIC_PASSWORD} \
        B2_ACCOUNT_ID=${secrets.backup.B2_ACCOUNT_ID} \
        B2_ACCOUNT_KEY=${secrets.backup.B2_ACCOUNT_KEY} \
        restic "$@"
    '';
  };
in
{
  options.backup = {
    enable = lib.mkEnableOption "backup";
    enableService = lib.mkEnableOption "enableService";
  };

  config = lib.mkIf config.backup.enable {
    home.packages = [ restic ];

    launchd.agents.restic-backup = {
      enable = config.backup.enableService && pkgs.stdenv.isDarwin;
      config = {
        ProgramArguments = [
          "${pkgs.bash}/bin/bash"
          "-c"
          "${restic}/bin/restic --cleanup-cache backup --exclude-file ${./excludes.txt} --one-file-system --exclude-caches --exclude-if-present .backupignore ~"
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
  };
}

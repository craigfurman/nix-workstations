{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:
{
  options.manageOtherMachines.enable = lib.mkEnableOption "manageOtherMachines";

  config =
    let
      nixosRebuildHost = pkgs.writeShellApplication {
        name = "nixos-rebuild-host";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          host="$1"
          nixos-rebuild switch \
            --flake "${config.home.homeDirectory}/${flakePath}#$host" \
            --target-host "$host" --build-host "$host" \
            --fast --use-remote-sudo
        '';
      };
    in
    lib.mkIf config.manageOtherMachines.enable {
      home.file.".ssh/config".text = ''
        Host thwomp
          Hostname 192.168.1.105
      '';

      home.packages = [ nixosRebuildHost ];
    };
}

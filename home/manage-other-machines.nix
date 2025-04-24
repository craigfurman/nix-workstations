{
  config,
  lib,
  pkgs,
  system,
  ...
}:
{
  options.manageOtherMachines.enable = lib.mkEnableOption "manageOtherMachines";

  config =
    let
      flakeName = if pkgs.stdenv.isDarwin then "nix-darwin" else "nixos";
      nixosRebuildHost = pkgs.writeShellApplication {
        name = "nixos-rebuild-host";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          host="$1"
          nixos-rebuild switch \
            --flake "${config.home.homeDirectory}/.config/${flakeName}#$host" \
            --target-host "$host" --build-host "$host" \
            --fast --use-remote-sudo
        '';
      };
    in
    lib.mkIf config.manageOtherMachines.enable {
      home.file.".ssh/config".text = ''
        Host chargin-chuck
          Hostname 192.168.1.115

        Host thwomp
          Hostname 192.168.1.105
      '';

      home.packages = [ nixosRebuildHost ];
    };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.manageOtherMachines = {
    enable = lib.mkEnableOption "manageOtherMachines";
    flakePath = lib.mkOption { type = lib.types.string; };
    user = lib.mkOption { type = lib.types.string; };
  };

  config =
    let
      cfg = config.manageOtherMachines;
      nixosRebuildHost = pkgs.writeShellApplication {
        name = "nixos-rebuild-host";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          host="$1"
          build_host="$2"

          export NIX_SSHOPTS="-o ForwardAgent=yes"
          nixos-rebuild switch \
            --flake "${cfg.flakePath}#$host" \
            --target-host "$host" --build-host "$build_host" \
            --fast --use-remote-sudo
        '';
      };
    in
    lib.mkIf cfg.enable {
      programs.ssh.extraConfig = ''
        Host *
          StrictHostKeyChecking accept-new

        Host chargin-chuck
          Hostname 192.168.1.115
          ForwardAgent yes
          User ${cfg.user}

        Host thwomp
          Hostname 192.168.1.105
          ForwardAgent yes
          User ${cfg.user}
      '';

      environment.systemPackages = [ nixosRebuildHost ];
    };
}

{
  pkgs,
  ...
}:
{
  config =
    let
      nixosRebuildHost = pkgs.writeShellApplication {
        name = "nixos-rebuild-host";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          host="$1"
          build_host="$2"

          export NIX_SSHOPTS="-o ForwardAgent=yes"
          nixos-rebuild switch \
            --flake "/etc/nix-darwin#$host" \
            --target-host "$host" --build-host "$build_host" \
            --fast --use-remote-sudo
        '';
      };
    in
    {
      programs.ssh.extraConfig = ''
        Host *
          StrictHostKeyChecking accept-new

        Host chargin-chuck
          Hostname 192.168.1.115

        Host thwomp
          Hostname 192.168.1.105
      '';

      environment.systemPackages = [ nixosRebuildHost ];
    };
}

{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.activation.makeTrampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    builtins.readFile ./make-app-trampolines.sh
  );

  # Mac apps
  # Some of these might arguably make more sense as nix-darwin systemPackages,
  # but I want to reuse the trampoline script without having too much
  # indirection.
  home.packages = with pkgs; [
    # ideally this would live in the bluesnooze darwin module
    bluesnooze
  ];
}

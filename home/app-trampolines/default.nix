{ lib, ... }:
{
  home.activation.makeTrampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    builtins.readFile ./make-app-trampolines.sh
  );
}

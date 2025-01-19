{ pkgs, ... }:
{
  # Mac apps
  # Some of these might arguably make more sense as nix-darwin systemPackages,
  # but I want to reuse the trampoline script without having too much
  # indirection.
  home.packages = with pkgs; [
    bluesnooze
  ];
}

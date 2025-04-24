{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file.".zshrc_hack".source =
    let
      flakeName = if pkgs.stdenv.isDarwin then "nix-darwin" else "nixos";
    in
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/${flakeName}/home/shell/hack.zsh";

  programs.zsh.initExtra = lib.mkAfter "source ~/.zshrc_hack";
}

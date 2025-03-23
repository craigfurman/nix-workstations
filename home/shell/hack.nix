{
  config,
  flakePath ? ".config/nix-darwin",
  lib,
  ...
}:
{
  home.file.".zshrc_hack".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${flakePath}/home/shell/hack.zsh";

  programs.zsh.initExtra = lib.mkAfter "source ~/.zshrc_hack";
}

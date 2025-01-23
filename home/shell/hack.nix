{
  config,
  lib,
  ...
}:
{
  home.file.".zshrc_hack".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/home/shell/hack.zsh";

  programs.zsh = {
    enable = true;

    # Keep effectively unlimited history
    initExtra = lib.mkAfter "source ~/.zshrc_hack";
  };
}

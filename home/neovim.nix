{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];

  programs.zsh.shellAliases = {
    vim = "nvim";
  };
}

{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      sensible
      yank
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  # TODO this breaks stuff
  # programs.neovim.plugins = [ pkgs.vimPlugins.vim-tmux-navigator ];
}

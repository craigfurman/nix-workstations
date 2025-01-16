{ pkgs, ... }:
let
  vim-kitty-navigator = pkgs.vimPlugins.vim-kitty-navigator;
in
{
  home.file = {
    ".config/kitty/pass_keys.py".source = "${vim-kitty-navigator}/pass_keys.py";
    ".config/kitty/get_layout.py".source = "${vim-kitty-navigator}/get_layout.py";
  };

  programs.neovim.plugins = [
    {
      plugin = pkgs.nvim-cmp_kitty;
      type = "lua";
      config = ''
        require('cmp_kitty'):setup()
      '';
    }
    vim-kitty-navigator
  ];

  programs.kitty = {
    keybindings = {
      "alt+down" = "kitten pass_keys.py bottom ctrl+j";
      "alt+up" = "kitten pass_keys.py top ctrl+k";
      "alt+left" = "kitten pass_keys.py left ctrl+h";
      "alt+right" = "kitten pass_keys.py right ctrl+l";
    };

    settings = {
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";
    };
  };
}

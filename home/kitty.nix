{ pkgs, ... }:
let
  vim-kitty-navigator = pkgs.vimPlugins.vim-kitty-navigator;
in
{
  home.file = {
    # vim-kitty-navigator
    ".config/kitty/pass_keys.py".source = "${vim-kitty-navigator}/pass_keys.py";
    ".config/kitty/get_layout.py".source = "${vim-kitty-navigator}/get_layout.py";
  };

  # vim-kitty-navigator
  programs.neovim.plugins = [ vim-kitty-navigator ];

  programs.kitty = {
    enable = true;

    extraConfig = builtins.readFile ./kitty.conf;

    keybindings = {

      # vim-kitty-navigator
      "alt+down" = "kitten pass_keys.py bottom ctrl+j";
      "alt+up" = "kitten pass_keys.py top ctrl+k";
      "alt+left" = "kitten pass_keys.py left ctrl+h";
      "alt+right" = "kitten pass_keys.py right ctrl+l";
    };

    settings = {
      # vim-kitty-navigator
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";
    };
  };
}

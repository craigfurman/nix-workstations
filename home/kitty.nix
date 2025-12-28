{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };

    keybindings = {
      "ctrl+shift+n" = "new_os_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "launch --cwd=current --location=split";
      "ctrl+shift+f4" = "launch --cwd=current --location=split";
      "ctrl+shift+f5" = "launch --cwd=current --location=hsplit";
      "ctrl+shift+f6" = "launch --cwd=current --location=vsplit";
      "ctrl+shift+f7" = "layout_action rotate";
      "ctrl+shift+z" = "toggle_layout stack";
      "f8" = "set_font_size 30"; # enormous font for screencasts
    };

    settings = {
      confirm_os_window_close = 0;
      copy_on_select = true;
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      enabled_layouts = "splits,stack";
      hide_window_decorations = true;
      scrollback_lines = 20000;
      scrollback_pager_history_size = 10; # MB
    }
    // (
      if pkgs.stdenv.isDarwin then
        {
          macos_option_as_alt = "left";
          macos_quit_when_last_window_closed = true;
        }
      else
        { }
    );
  };
}

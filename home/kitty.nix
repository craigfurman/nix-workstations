{
  programs.kitty = {
    enable = true;

    font = {
      name = "Inconsolata Nerd Font Mono";
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
    };

    settings = {
      cursor_blink_interval = 0;
      copy_on_select = true;
      enabled_layouts = "splits,stack";
      hide_window_decorations = true;
      confirm_os_window_close = 0;
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = true;
      scrollback_lines = 20000;
      scrollback_pager_history_size = 10; # MB
    };
  };
}

{
  programs.neovim = {
    extraConfig = ''
      " Save on focus lost
      autocmd BufLeave,FocusLost * silent! update
    '';

    extraLuaConfig = builtins.readFile ./config/config.lua;
  };
}

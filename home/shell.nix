{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;

    # Keep effectively unlimited history
    history.save = 1000000000;

    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };

    shellAliases = {
      ll = "ls -lah";
    };
  };
}

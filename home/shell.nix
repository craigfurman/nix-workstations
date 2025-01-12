let
  tintedShellRepo = builtins.fetchGit {
    url = "https://github.com/tinted-theming/tinted-shell.git";
    ref = "main";
    rev = "839f96d22a5b3a702444b2b19513b2e751ff748a";
  };
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;

    # Keep effectively unlimited history
    history.save = 1000000000;

    initExtra = ''
      source ${tintedShellRepo}/profile_helper.sh
      base16_gruvbox-dark-medium
    '';

    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };

    shellAliases = {
      ll = "ls -lah";
    };
  };
}

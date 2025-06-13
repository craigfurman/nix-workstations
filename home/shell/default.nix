{ lib, pkgs, ... }:
let
  tintedShellRepo = builtins.fetchGit {
    url = "https://github.com/tinted-theming/tinted-shell.git";
    ref = "main";
    rev = "7b81c394be07b3e7a3a4713c6ab0e2154eb90e14";
  };
in
{
  imports = [ ./hack.nix ];

  home.packages = lib.mkIf pkgs.stdenv.isDarwin [ pkgs.coreutils-prefixed ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.dircolors.enable = true;

  programs.zsh = {
    enable = true;

    # Keep effectively unlimited history
    history.save = 1000000000;
    history.size = 1000000000;

    initContent = ''
      source ${tintedShellRepo}/profile_helper.sh
      base16_gruvbox-dark-medium
    '';

    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        zstyle ':omz:lib:theme-and-appearance' gnu-ls yes
      '';

      theme = "bira";
    };

    shellAliases = {
      ll = "ls -lah";
    };
  };
}

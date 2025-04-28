{ lib, pkgs, ... }:
let
  tintedShellRepo = builtins.fetchGit {
    url = "https://github.com/tinted-theming/tinted-shell.git";
    ref = "main";
    rev = "839f96d22a5b3a702444b2b19513b2e751ff748a";
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

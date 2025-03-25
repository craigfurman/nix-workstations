extra:
{
  lib,
  nixpkgs,
  pkgs,
  ...
}:
lib.recursiveUpdate {
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  imports = [
    ./apps
    ./backup
    ./git.nix
    ./kitty.nix
    ./lang
    ./neovim
    ./neovim-kitty-integration.nix
    ./shell
    ./ssh.nix
  ];

  home.packages =
    with pkgs;
    lib.flatten (
      [
        # GNUtils
        coreutils
        diffutils
        findutils
        gawk
        gnugrep
        gnumake
        gnused
        gnutar

        age
        ansible
        curl
        fd
        htop
        nixfmt-rfc-style
        tree
        unixtools.watch
        wget
      ]
      ++ lib.optional pkgs.stdenv.isDarwin [ lima ]
    );

  nix = {
    # nix-shell and friends use the same nixpkgs revision as this flake
    channels = { inherit nixpkgs; };

    # Darwin defines its own GC.
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg";
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob"
      "  !.git"
    ];
  };
} extra

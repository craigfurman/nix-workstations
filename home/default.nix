{
  nixpkgs,
  pkgs,
  ...
}:
{
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
    ./app-trampolines
    ./apps.nix
    ./backup
    ./git.nix
    ./kitty.nix
    ./lang
    ./neovim
    ./neovim-kitty-integration.nix
    ./shell
  ];

  home.packages = with pkgs; [
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
  ];

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
}

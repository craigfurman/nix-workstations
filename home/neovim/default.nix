{ config, pkgs, ... }:
let
  pluginLua = plugin: {
    plugin = pkgs.vimPlugins.${plugin};
    type = "lua";

    # These configs are appended to ~/.config/nvim/init.lua
    config = builtins.readFile ./config/plugin/${plugin}.lua;
  };
in
{
  imports = [
    ./config.nix
    ./hack.nix
    ./treesitter.nix # TODO is this working?
  ];

  home.file.".config/nvim/lua/hack.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/home/neovim/config/hack.lua";

  programs.neovim = {
    enable = true;

    extraLuaConfig = pkgs.lib.mkBefore (builtins.readFile ./config/prelude.lua);

    plugins = with pkgs.vimPlugins; [
      (pluginLua "nvim-lspconfig")
      (pluginLua "lspsaga-nvim")

      {
        plugin = base16-vim;
        config = ''
          let base16_colorspace=256
          colorscheme base16-$BASE16_THEME
        '';
      }

      (pluginLua "lualine-nvim")

      (pluginLua "telescope-nvim")
      (pluginLua "nvim-tree-lua")
      nvim-web-devicons

      # Core
      vim-commentary
      vim-fugitive
      vim-rhubarb
      vim-surround
      vim-signify
    ];
  };

  programs.zsh.shellAliases = {
    vim = "nvim";
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
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
    ./treesitter.nix
  ];

  home.file.".config/nvim/lua/hack.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/home/neovim/config/hack.lua";

  programs.neovim = {
    enable = true;

    extraLuaConfig = lib.mkBefore (builtins.readFile ./config/prelude.lua);

    plugins = with pkgs.vimPlugins; [
      # Language servers
      (pluginLua "nvim-lspconfig")
      (pluginLua "lspsaga-nvim")

      # Appearance
      {
        plugin = tinted-vim;
        config = ''
          let tinted_colorspace=256
          colorscheme base16-$BASE16_THEME
        '';
      }
      (pluginLua "lualine-nvim")

      # Navigation
      (pluginLua "telescope-nvim")
      (pluginLua "nvim-tree-lua")
      nvim-web-devicons

      (pluginLua "vim-test")

      # Autocomplete
      (pluginLua "nvim-cmp")
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup {}
        '';
      }
      {
        plugin = nvim-treesitter-endwise;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
              endwise = {
                  enable = true,
              },
          }
        '';
      }

      # Core
      vim-commentary
      vim-fugitive
      vim-rhubarb
      vim-signify
      vim-surround
      which-key-nvim
    ];
  };

  programs.zsh.shellAliases = {
    vim = "nvim";
  };
}

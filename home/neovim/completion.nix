{ pkgs, ... }:
{
  programs.neovim = {
    extraLuaConfig = builtins.readFile ./config/completion.lua;

    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-treesitter-endwise

      {
        plugin = luasnip;
        type = "lua";
        config = ''
          require("luasnip.loaders.from_snipmate").lazy_load({
            ['paths'] = {'${./snippets}'}
          })
        '';
      }
      cmp_luasnip

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup {}
        '';
      }
    ];
  };
}

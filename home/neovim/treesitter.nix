{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.neovim.craigf.treesitterParsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    programs.neovim.plugins =
      let
        baseParsers = [
          "comment"
          "cpp"
          "css"
          "gomod"
          "html"
          "json"
          "lua"

          # Needed for Lspsaga hover_doc
          "markdown"
          "markdown_inline"

          "ruby"
          "rust"
          "vim"
          "vimdoc"
          "yaml"
        ];
        parsers = config.programs.neovim.craigf.treesitterParsers ++ baseParsers;
        nvim-treesitter = {
          plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (parser: p.${parser}) parsers);

          type = "lua";
          config =
            let
              parserLuaStrings = map (parser: "\"${parser}\"") parsers;
            in
            ''
              require('nvim-treesitter').setup({})
              vim.api.nvim_create_autocmd('FileType', {
                pattern = { ${lib.strings.concatStringsSep "," parserLuaStrings} },
                callback = function() vim.treesitter.start() end,
              })
            '';
        };

        rainbow-delimiters-nvim = {
          plugin = pkgs.vimPlugins.rainbow-delimiters-nvim;
          type = "lua";
          config = ''
            require('rainbow-delimiters.setup').setup {
                highlight = {
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                },
            }
          '';
        };
      in
      [
        nvim-treesitter
        rainbow-delimiters-nvim
      ];
  };
}

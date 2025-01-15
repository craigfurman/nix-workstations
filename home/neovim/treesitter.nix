{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.neovim.craigExtensions.treesitterParsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    programs.neovim.plugins = [
      {
        plugin =
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

              "python"
              "ruby"
              "rust"
              "vim"
              "vimdoc"
              "yaml"
            ];
            parsers = config.programs.neovim.craigExtensions.treesitterParsers ++ baseParsers;
          in
          pkgs.vimPlugins.nvim-treesitter.withPlugins (p: builtins.map (parser: p.${parser}) parsers);

        type = "lua";
        config = builtins.readFile ./config/plugin/nvim-treesitter.lua;
      }
    ];
  };
}

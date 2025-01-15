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
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        p: builtins.map (parser: p.${parser}) config.programs.neovim.craigExtensions.treesitterParsers
      ))
    ];
  };
}

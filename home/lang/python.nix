{ craigLib, pkgs, ... }:
{
  programs.neovim = {
    craigExtensions.treesitterParsers = [ "python" ];

    extraConfig = ''
      ${craigLib.neovim.preSaveCommand [ "py" ] "lua vim.lsp.buf.format({timeout_ms=1000})"}
    '';

    extraLuaConfig = ''
      vim.lsp.config('pylsp', {})
      vim.lsp.enable('pylsp')
    '';

    extraPackages = [
      (pkgs.python3.withPackages (
        pypkgs: [ pypkgs.python-lsp-server ] ++ pypkgs.python-lsp-server.optional-dependencies.all
      ))
    ];
  };
}

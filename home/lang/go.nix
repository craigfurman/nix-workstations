{ craigLib, pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    golangci-lint
    golangci-lint-langserver
    gopls
  ];

  programs.neovim = {
    craigExtensions.treesitterParsers = [ "go" ];

    extraConfig =
      let
        extensions = [ "go" ];
      in
      ''
        ${craigLib.neovim.fileOpenCommand extensions "setlocal noexpandtab"}
        ${craigLib.neovim.preSaveCommand extensions "lua lsp_imports_and_format(1000)"}
        autocmd BufEnter go.mod set ft=gomod
        autocmd BufEnter *.gohtml set ft=html
      '';

    extraLuaConfig = builtins.readFile ./go-ls.lua;
  };
}

{ flake, pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    golangci-lint
  ];

  programs.neovim = {
    craigf.treesitterParsers = [ "go" ];

    extraConfig =
      let
        extensions = [ "go" ];
      in
      ''
        ${flake.lib.neovim.fileOpenCommand extensions "setlocal noexpandtab"}
        ${flake.lib.neovim.preSaveCommand extensions "lua lsp_imports_and_format(1000)"}
        autocmd BufEnter go.mod set ft=gomod
        autocmd BufEnter *.gohtml set ft=html
      '';

    extraLuaConfig = builtins.readFile ./go-ls.lua;

    extraPackages = with pkgs; [
      gopls
      golangci-lint-langserver
    ];
  };
}

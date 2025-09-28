{ craigLib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
  ];

  programs.neovim = {
    craigExtensions.treesitterParsers = [ "nix" ];

    extraConfig =
      let
        extensions = [ "nix" ];
      in
      ''
        ${craigLib.neovim.preSaveCommand extensions "lua vim.lsp.buf.format({timeout_ms=1000})"}
      '';

    extraLuaConfig = builtins.readFile ./nil-ls.lua;
  };
}

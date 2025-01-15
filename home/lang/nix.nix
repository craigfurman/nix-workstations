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
        ${craigLib.neovim.preSaveCommand extensions "lua lsp_imports_and_format(1000)"}
      '';

    extraLuaConfig = builtins.readFile ./nil-ls.lua;
  };
}

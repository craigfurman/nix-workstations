{ craigLib, pkgs, ... }:
{
  home.packages = with pkgs; [
    elixir
    elixir-ls
  ];

  programs.neovim = {
    craigExtensions.treesitterParsers = [ "elixir" ];

    extraConfig =
      let
        extensions = [
          "ex"
          "exs"
        ];
      in
      ''
        ${craigLib.neovim.preSaveCommand extensions "lua lsp_imports_and_format({})"}
      '';

    extraLuaConfig = ''
      require'lspconfig'.elixirls.setup{
        cmd = { "${"${pkgs.elixir-ls}/lib/language_server.sh"}" },
      }
    '';
  };
}

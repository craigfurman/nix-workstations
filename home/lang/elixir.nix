{ craigLib, pkgs, ... }:
{
  home.packages = with pkgs; [
    elixir
    elixir-ls
  ];

  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_file_bytes 1048576"; # 1MB
  };

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

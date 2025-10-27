{
  craigLib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    elixir
  ];

  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_file_bytes 1048576"; # 1MB
  };

  programs.neovim = {
    craigExtensions.treesitterParsers = [
      "elixir"
      "heex"
    ];

    extraConfig =
      let
        extensions = [
          "ex"
          "exs"
          "heex"
        ];
      in
      ''
        ${craigLib.neovim.preSaveCommand extensions "lua vim.lsp.buf.format({timeout_ms=1000})"}
      '';

    extraLuaConfig = ''
      vim.lsp.config('elixirls', {
        cmd = { "${"${pkgs.elixir-ls}/scripts/language_server.sh"}" },
      })
      vim.lsp.enable('elixirls')
    '';
  };
}

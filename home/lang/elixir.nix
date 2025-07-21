{
  craigLib,
  pkgs,
  system,
  ...
}:
let
  pinnedNixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/05580f4b4433fda48fff30f60dfd303d6ee05d21.tar.gz";
    sha256 = "sha256:073raa2a5f72xqkz0k481djq9xvz0bgxbhffzw5aqlv5iagzbmap";
  }) { inherit system; };
in
{
  home.packages = [
    pkgs.elixir

    # https://github.com/elixir-lsp/elixir-ls/issues/1219
    pinnedNixpkgs.elixir-ls
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
        ${craigLib.neovim.preSaveCommand extensions "lua lsp_imports_and_format({})"}
      '';

    extraLuaConfig = ''
      require'lspconfig'.elixirls.setup{
        cmd = { "${"${pinnedNixpkgs.elixir-ls}/lib/language_server.sh"}" },
      }
    '';
  };
}

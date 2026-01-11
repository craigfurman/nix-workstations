{ flake, pkgs, ... }:
{
  home.packages = [ pkgs.nixfmt ];

  programs.neovim = {
    craigf.treesitterParsers = [ "nix" ];

    extraConfig = ''
      ${flake.lib.neovim.preSaveCommand [ "nix" ] "lua vim.lsp.buf.format({timeout_ms=1000})"}
    '';

    extraLuaConfig = "vim.lsp.enable('nixd')";
    extraPackages = [ pkgs.nixd ];
  };
}

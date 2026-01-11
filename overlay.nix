final: prev: {
  vimPlugins = prev.vimPlugins // {
    # Until https://github.com/NixOS/nixpkgs/pull/479005
    nvim-treesitter-endwise = prev.vimPlugins.nvim-treesitter-endwise.overrideAttrs {
      dependencies = [ final.vimPlugins.nvim-treesitter ];
    };
  };

  # https://github.com/nixos/nixpkgs/issues/475202
  wireplumber = prev.wireplumber.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "0.5.12";
      src = prevAttrs.src.override {
        rev = finalAttrs.version;
        hash = "sha256-3LdERBiPXal+OF7tgguJcVXrqycBSmD3psFzn4z5krY=";
      };
    }
  );
}

final: prev: {
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

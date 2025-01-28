{ lib, ... }:
{
  # This still comes before plugin config. I'm not sure why. Might have to fix
  # that one day.
  programs.neovim.extraLuaConfig = lib.mkAfter "require('hack')";
}

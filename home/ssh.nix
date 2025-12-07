{ pkgs, ... }:
{
  home.file.".ssh/config".text =
    if pkgs.stdenv.isDarwin then
      ''
        Host *
          UseKeychain yes
          AddKeysToAgent yes
      ''
    else
      "";
}

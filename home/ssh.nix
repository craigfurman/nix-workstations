{ pkgs, ... }:
{
  home.file.".ssh/config".text =
    if pkgs.stdenv.isDarwin then
      ''
        Host *
          IdentityAgent ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
          UseKeychain yes
          AddKeysToAgent yes
      ''
    else
      "";
}

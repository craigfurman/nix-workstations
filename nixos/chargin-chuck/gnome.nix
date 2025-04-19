{ gnomeExtensions, pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = map (
    gnomeExtension: pkgs.gnomeExtensions.${gnomeExtension}
  ) gnomeExtensions;
}

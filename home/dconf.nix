{
  config,
  gnomeExtensions,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dconf.enable {
    home.packages = [ pkgs.dconf-editor ];

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:escape" ];
      };
      "org/gnome/desktop/interface" = {
        # This doesn't do anything, the type has to be an integer here even though
        # we've configured fractional scaling support below.
        # scaling-factor = 1.5;

        text-scaling-factor = 1.5;
      };
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };

      "org/gnome/shell" = {
        enabled-extensions = map (
          gnomeExtension: pkgs.gnomeExtensions.${gnomeExtension}.extensionUuid
        ) gnomeExtensions;
      };
    };
  };
}

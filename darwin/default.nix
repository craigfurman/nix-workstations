{ pkgs, ... }:
{
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false; # disable natural scrolling
      AppleInterfaceStyleSwitchesAutomatically = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false; # disable smart quotes
    };

    controlcenter.Sound = true;

    dock = {
      autohide = true;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/Applications/Brave Browser.app"
      ];
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    trackpad.Clicking = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.startup.chime = false;

  # Integrates with home-manager
  users.users.craig.home = "/Users/craig";
}

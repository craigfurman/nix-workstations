{ pkgs, ... }:
{
  environment.shells = [ pkgs.zsh ];

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false; # disable natural scrolling
      AppleInterfaceStyleSwitchesAutomatically = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false; # disable smart quotes
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    controlcenter.Sound = true;

    dock = {
      autohide = true;

      persistent-apps =
        let
          hmApps = [ "kitty" ];
        in
        [
          "/System/Applications/Launchpad.app"
          "/Applications/Brave Browser.app"
          "/Applications/Todoist.app"
          "/Applications/Discord.app"
          "/Applications/Signal.app"
          "/Applications/WhatsApp.app"
        ]
        ++ map (hmApp: "/Users/craig/Applications/Home Manager Apps/${hmApp}.app") hmApps;
    };

    finder.FXPreferredViewStyle = "Nlsv"; # list view

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

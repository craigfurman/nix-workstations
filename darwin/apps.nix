{
  imports = [
    ./autokbisw.nix
    ./bluesnooze.nix
  ];

  homebrew = {
    enable = true;

    brews = [
      # Don't uninstall mas after every run
      { name = "mas"; }
    ];

    casks =
      let
        casks = [
          # casks that auto-update, and therefore don't need to be brew-upgraded
          # once installed
          # "brave-browser" # TODO uncomment on a fresh machine
          "discord"
          "google-chrome"
          "obsidian"
          "rectangle"
          "signal"
          "slack"
          "steam"
          "visual-studio-code"
          "vlc"
          "whatsapp"
          "zoom"

          # This must run from /Applications. This is the easiest route, even
          # though it won't update. I'll have to manually brew-upgrade it from
          # time to time, which is a bit sad.
          "secretive"
        ];
      in
      map (cask: { name = cask; }) casks;

    masApps = {
      Bitwarden = 1352778147;
      Flycut = 442160987;
      NordVPN = 905953485;
      Todoist = 585829637;
    };

    onActivation.cleanup = "zap";
  };

}

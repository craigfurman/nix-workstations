{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.autokbisw ];

  homebrew = {
    enable = true;

    casks =
      let
        cask = name: { name = name; };
      in
      [
        # casks that auto-update, and therefore don't need to be brew-upgraded
        # once installed
        # (cask "brave-browser") # TODO uncomment on a fresh machine
        (cask "discord")
        (cask "google-chrome")
        (cask "obsidian")
        (cask "rectangle")
        (cask "signal")
        (cask "slack")
        (cask "steam")
        (cask "visual-studio-code")
        (cask "vlc")
        (cask "whatsapp")
        (cask "zoom")

        # This must run from /Applications. This is the easiest route, even
        # though it won't update. I'll have to manually brew-upgrade it from
        # time to time, which is a bit sad.
        (cask "secretive")
      ];

    masApps = {
      Bitwarden = 1352778147;
      Flycut = 442160987;
      NordVPN = 905953485;
      Todoist = 585829637;
    };

    onActivation.cleanup = "zap";
  };

  # Currently, giving autokbisw the ability to monitor keyboard input is a
  # manual step. I don't think nix-darwin supports this yet.
  launchd.user.agents.autokbisw = {
    command = "${pkgs.autokbisw}/bin/autokbisw";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/autokbisw.log";
      StandardErrorPath = "/tmp/autokbisw.log";
    };
  };
}

# nix-workstations

Nix config for my computer(s). Most of the functionality from
<https://github.com/craigfurman/ansible-home> is ported over, but there will
probably be a long tail of unported stuff for some time.

## Macs

My personal laptop makes use of
[nix-darwin](https://github.com/LnL7/nix-darwin).

### New machine setup

1. Install nix: <https://nixos.org/download/#nix-install-macos>
1. Install Homebrew
   1. Yes, it's odd to install another package manager before even using nix! I
      use Homebrew to install some GUI apps that either self-update or are not
      available in nixpkgs.
1. `nix-shell -p git git-crypt`
1. `git clone git@github.com:craigfurman/nix-workstations.git ~/.config/nix-darwin`
1. `cd ~/.config/nix-darwin`
1. `git-crypt unlock <key>`
1. `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`
1. After the first run, `darwin-rebuild` should become available.
1. `chsh -s /run/current-system/sw/bin/zsh`
   1. It might be possible to automate this by setting
      https://daiderd.com/nix-darwin/manual/index.html#opt-users.knownUsers, but
      I'm a bit paranoid about accidentally deleting my user account.
1. Remove unused channels (home-manager ensures that a channel pinned to the
   flake's nixpkgs is made available for nix-shell and friends)
   1. `nix-channel --remove nixpkgs`
   1. `sudo nix-channel --remove nixpkgs`
   1. `nix-channel --list` and `sudo nix-channel --list` should both return
      empty.
1. Uninstall the original nix version, now that nix-darwin manages it
   1. Accomplish this by uninstalling all packages from user and root's default
      profiles. All packages should be managed by nix-darwin / HM / other
      flakes.
   1. `nix profile list`
   1. For each package, `nix-env --uninstall <package>`
   1. Repeat steps with `sudo`
1. `nix doctor`

#### Other config

1. Enable FileVault

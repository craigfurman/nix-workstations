# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  secrets,
  ...
}:

{
  imports = [
    ../base
    ../nordvpn.nix
    ./hardware-configuration.nix
    ./suspend-nightly.nix
  ];

  boot.loader.grub = {
    enable = true;

    configurationLimit = 5;
    device = "/dev/sdd";
  };

  environment.etc =
    let
      privateFile = text: {
        inherit text;
        mode = "0600";
      };
    in
    {
      crypttab = privateFile ''
        data0 UUID=673a8895-136a-465b-95fc-b02fb8e77f94 /etc/luks_password luks,timeout=10
        data1 UUID=27b76ab0-47d3-4375-b0f0-8e7ce532b17c /etc/luks_password luks,timeout=10
      '';
      luks_password = privateFile secrets.luksPassword;
    };

  environment.systemPackages = with pkgs; [
    cryptsetup
    git
    git-crypt
    htop
    lsof
    vim
  ];

  fileSystems."/media/data" = {
    device = "/dev/disk/by-uuid/9dd53dc7-638f-429a-a3ad-e4a74cae2f66";
    fsType = "btrfs";
    options = [
      "rw"
      "relatime"
      "space_cache"
      "subvol=/data"
    ];
  };

  networking.hostName = "thwomp";

  time.timeZone = "Europe/London";

  # Avoid chgrp'ing massive directories, reuse old GID
  users.groups.data = {
    gid = 2000;
    members = [ "craig" ];
  };

  users.users.craig = {
    isNormalUser = true;
    description = "Craig Furman";
    extraGroups = [ "wheel" ];
  };

  services.custom.nordvpn = {
    enable = true;
    users = [ "craig" ];
  };

  services.custom.ssh-server = {
    enable = true;
    authorizedKeys = secrets.authorizedKeys;
  };

  services.plex = {
    enable = true;
    dataDir = "/media/data/plex";
    group = "data";
    openFirewall = true;
  };

  services.transmission = {
    enable = true;
    group = "data";
    openRPCPort = true;
    package = pkgs.transmission_4;

    # https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md
    settings = {
      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = "/media/data/Downloads";
      encryption = 1;
      message-level = 1;
      rpc-bind-address = "0.0.0.0";
      rpc-enabled = true;
      rpc-port = 9091;
      rpc-whitelist = "127.0.0.1,192.168.*.*,thwomp";
      rpc-whitelist-enabled = true;
      umask = "002";
      utp-enabled = false;
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

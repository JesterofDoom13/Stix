{
  pkgs,
  config,
  user,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
    extraModulePackages = [
      config.boot.kernelPackages.gcadapter-oc-kmod
    ];
    kernelModules = [
      "gcadapter_oc"
    ];
    plymouth = {
      enable = true;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "btrfs" ];
  };

  jovian = {
    devices.steamdeck.enable = true;
    decky-loader = {
      enable = true;
      extraPythonPackages = p: [
        p.requests
        p.pillow
      ];
    };
    steam = {
      enable = true;
      autoStart = true;
      inherit user;
      desktopSession = "niri";
    };
  };

  # Niri
  programs.niri.enable = true;
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;

  # Noctalia - Just in case we didn't get it from Jovian-NixOS
  # All labeled as requirements under Noctalia docs for NixOS

  # networking is supported but if you put this in a different conifg enable it.
  # networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Retrodeck - Enabling Flatpaks and installing it
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "net.retrodeck.retrodeck"
  ];
  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "/var/lib/flatpak/exports/share"
      "$HOME/.local/share/flatpak/exports/share"
    ];
  };

  # Force Wayland for all Flatpaks globally
  services.flatpak.overrides = {
    global = {
      Context.sockets = [
        "wayland"
        "!x11"
        "!fallback-x11"
      ];
      Environment = {
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };
    };
  };

  # Security / auth
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  # Graphics
  hardware.graphics.enable = true;
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # XDG portals
  xdg = {
    mime.defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
    };
    portal = {
      enable = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gnome
      ];
      config.niri = {
        default = [
          "kde"
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.imp.portal.AppChooser" = "kde";
        # "default" = [ "gtk" ];
      };
    };
  };
  # in configuration.nix
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  console.useXkbConfig = true;
  services = {
    udev.packages = [ pkgs.dolphin-emu ];
    gnome.gnome-keyring.enable = true;
    xserver.xkb.options = "caps:swapescape";
    # Btrfs maintenance
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    # Snapper snapshots
    snapper = {
      snapshotInterval = "hourly";
      cleanupInterval = "1d";
      configs = {
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ user ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_MIN_AGE = "1800";
          TIMELINE_LIMIT_HOURLY = "10";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "6";
          TIMELINE_LIMIT_YEARLY = "2";
        };
        root = {
          SUBVOLUME = "/";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_MIN_AGE = "1800";
          TIMELINE_LIMIT_HOURLY = "5";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "2";
          TIMELINE_LIMIT_MONTHLY = "3";
          TIMELINE_LIMIT_YEARLY = "1";
        };
      };
    };

    # Smart card support (for CAC)
    pcscd.enable = true;

    openssh.enable = true;
  };

  # Networking
  networking.hostName = "kharon";
  networking.networkmanager.enable = true;
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714; # kde-connect
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  services.tailscale.enable = true;

  # Locale / time
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "audio"
      "networkmanager"
      "lpadmin"
    ];
    shell = pkgs.fish;
  };

  # System-level packages (minimal — rest in home.nix)
  home-manager.backupFileExtension = "hmup";
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    xwayland-satellite
  ];

  programs.fish.enable = true;

  nix.settings = {
    accept-flake-config = true;
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "25.11";
}

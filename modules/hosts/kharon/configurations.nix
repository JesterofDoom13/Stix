{ inputs, ... }: {
  flake.modules.nixos.kharon = { pkgs, ... }:
    {

      imports = with inputs.self.modules.nixos;
        [
          home-manager
        ];
      networking.hostName = "kharon";
      nixpkgs.config.allowUnfree = true;

      nixpkgs.config.permittedInsecurePackages = [
        "pnpm-9.15.9"
      ];
      nixpkgs.overlays = [
        (final: prev: {
          openldap = prev.openldap.overrideAttrs (_: {
            doCheck = false;
          });
        })
        (final: prev: {
          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (pyFinal: pyPrev: {
              pyrate-limiter = pyPrev.pyrate-limiter.overridePythonAttrs (old: {
                disabledTests = (old.disabledTests or [ ]) ++ [
                  "test_limiter_async_factory_get"
                  "test_bucket_factory"
                ];
              });
            })
          ];
        })
      ];

      jovian.devices.steamdeck.enable = true;
      boot = {
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
        kernelModules = [
          "gcadapter_oc"
        ];
        plymouth = {
          enable = true;
        };
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        supportedFilesystems = [
          "btrfs"
        ];
      };

      # Niri
      # programs.niri = {
      #   enable = true;
      #   package = pkgs.niri-unstable;
      # };
      programs.kdeconnect.enable = true;
      programs.dconf.enable = true;

      environment.sessionVariables = {
        # QT_QPA_PLATFORMTHEME = "qt6ct";
        XDG_DATA_DIRS = [
          "/var/lib/flatpak/exports/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      };

      # Force Wayland for all Flatpaks globally
      # services.flatpak.overrides = {
      #   global = {
      #     Context.sockets = [
      #       "wayland"
      #       "!x11"
      #       "!fallback-x11"
      #     ];
      #     Environment = {
      #       XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      #     };
      #   };
      # };
      # networking is supported but if you put this in a different conifg enable it.
      # networking.networkmanager.enable = true;
      services.udisks2.enable = true;
      hardware.bluetooth.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
      services.pipewire.wireplumber.extraConfig."51-hdmi-surround71" = {
        "monitor.alsa.rules" = [
          {
            matches = [{ "device.name" = "alsa_card.pci-0000_04_00.1"; }];
            actions.update-props = {
              "device.profile" = "output:hdmi-surround71-extra2";
            };
          }
          {
            matches = [{ "node.name" = "alsa_output.pci-0000_04_00.1.hdmi-surround71*"; }];
            actions.update-props = {
              "priority.session" = 2000;
              "priority.driver" = 2000;
            };
          }
        ];
      };

      # Security / auth
      security.polkit.enable = true;
      # security.pam.services.swaylock = { };

      # Graphics
      hardware.graphics.enable = true;
      hardware.logitech.wireless.enable = true;
      # hardware.logitech.wireless.enableGraphical = true;
      # replacing line above with line below
      programs.solaar.enable = true;

      # XDG portals
      xdg = {
        # mime.defaultApplications = {
        #   "inode/directory" = [ "org.kde.dolphin.desktop" ];
        # };
        portal = {
          enable = true;
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
          # config.niri = {
          #   default = [
          #     "kde"
          #     "gnome"
          #     "gtk"
          #   ];
          #   "org.freedesktop.impl.portal.FileChooser" = "kde";
          #   "org.freedesktop.imp.portal.AppChooser" = "kde";
          #   # "default" = [ "gtk" ];
          # };
        };
      };

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

      };

      # Networking
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
      services.tailscale.enable = true;

      # Locale / time
      time.timeZone = "America/Denver";
      i18n.defaultLocale = "en_US.UTF-8";

      # System-level packages (minimal — rest in home.nix)
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

    };
}



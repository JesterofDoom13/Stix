{ inputs, ... }: {
  flake.modules.nixos.gamix = { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos;
        [
          home-manager
          "${inputs.nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"
        ];
      nix.settings = { sandbox = false; };
      systemd.network.wait-online.enable = false;
      security.pam.services.sshd.allowNullPassword = true;
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = true;
          PermitEmptyPasswords = "yes";
        };
      };

      proxmoxLXC = {
        privileged = true;
        manageNetwork = false;
        manageHostName = false;
      };

      networking.hostName = "gamix";
      nixpkgs.config.allowUnfree = true;
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

      programs.dconf.enable = true;

      environment.sessionVariables = {
        # QT_QPA_PLATFORMTHEME = "qt6ct";
        XDG_DATA_DIRS = [
          "/var/lib/flatpak/exports/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      };

      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # Security / auth
      security.polkit.enable = true;
      # security.pam.services.swaylock = { };

      # Graphics
      hardware.graphics.enable = true;

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
        };
      };

      console.useXkbConfig = true;
      services = {
        xserver.xkb.options = "caps:swapescape";
      };

      # Networking
      networking.networkmanager.enable = true;
      services.tailscale.enable = true;

      # Locale / time
      time.timeZone = "America/Denver";
      i18n.defaultLocale = "en_US.UTF-8";
    };
}

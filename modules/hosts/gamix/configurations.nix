{ inputs, ... }: {
  flake.modules.nixos.gamix = { modulesPath, lib, ... }:
    {
      imports = with inputs.self.modules.nixos;
        [
          home-manager
          prox-nvidia
          (modulesPath + "/virtualisation/proxmox-lxc.nix")
        ];
      nix.settings = { sandbox = false; };
      proxmoxLXC = {
        privileged = true;
        manageNetwork = false;
        manageHostName = false;
      };

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
          xdg-desktop-portal = prev.xdg-desktop-portal.overrideAttrs (_: {
            doCheck = false;
          });
        })
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
      #-- For Umbriel ------------------------------
      services.greetd = {
        enable = true;
        settings = rec {
          terminal.vt = lib.mkForce 7;
          initial_session = {
            command = "start-umbriel";
            user = "Jester";
          };
          default_session = initial_session;
        };
      };

      jovian.steam.autoStart = lib.mkForce false;
      services.displayManager.sddm.enable = lib.mkForce false;

      users.users.Jester.linger = true;
      #----------------------------------------------

      systemd.user.services.sunshine.environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
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

      # Graphics
      hardware.graphics.enable = true;

      # XDG portals
      xdg.portal.enable = true;

      console.useXkbConfig = true;
      services = {
        xserver.xkb.options = "caps:swapescape";
      };

      #-- Networking ------------------------------
      #------DO NOT REMOVE ------------------------
      networking.hostName = "gamix";
      systemd.additionalUpstreamSystemUnits = [ "systemd-udev-trigger.service" ];
      systemd.services.systemd-rfkill = {
        wantedBy = lib.mkForce [ ];
        enable = false;
      };
      systemd.network.wait-online.enable = false;
      #------DO NOT REMOVE ------------------------
      security.pam.services.sshd.allowNullPassword = true;
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          PermitEmptyPasswords = "yes";
        };
      };
      services.tailscale.enable = true;

      #-- Locale / time----------------------------
      time.timeZone = "America/Denver";
      i18n.defaultLocale = "en_US.UTF-8";
    };
}

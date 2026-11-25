{
  flake.modules.homeManager.keepassxc = { pkgs, ... }:
    {
      xdg.autostart.enable = true;
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-egui;
      };
      systemd.user.services.kpxc-keyfile = {
        Unit = {
          Description = "Decrypt KeePassXC key file to tmpfs";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "kpxc-keyfile-start" ''
            umask 077
            ${pkgs.gnupg}/bin/gpg --quiet --decrypt \
              "$HOME/.password-store/keepass/keyfile.gpg" > "$XDG_RUNTIME_DIR/kpxc.key.tmp"
            mv "$XDG_RUNTIME_DIR/kpxc.key.tmp" "$XDG_RUNTIME_DIR/kpxc.key"
          '';
          ExecStop = "${pkgs.coreutils}/bin/rm -f %t/kpxc.key %t/kpxc.key.tmp";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      programs = {
        keepassxc = {
          enable = true;
          autostart = true;
        };
        umbriel = {
          settings = {
            scratchpad = [
              {
                name = "keepass";
                spawn_when_empty = "keepassxc";
              }
            ];
            window_rule = [
              {
                match.app_id = "^org[.]keepassxc[.]KeePassXC$";
                default_scratchpad = "keepass";
                default_floating_size = { width = 0.5; height = 0.6; };
                default_position = { x = 0; y = 0; anchor = "center"; };
              }
            ];
            keybinds = {
              "Mod+Shift+P" = { action = "scratchpad-toggle keepass"; repeat = false; };
            };
          };
        };
      };
    };
}


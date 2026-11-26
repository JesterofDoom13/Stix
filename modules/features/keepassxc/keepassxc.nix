{
  flake.modules.homeManager.keepassxc = { pkgs, config, ... }:
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
      services.syncthing.settings.folders."keepassdx" = {
        path = "${config.home.homeDirectory}/.password-store/keepass";
        devices = [ "S23Ultra" ];
        type = "sendreceive";
      };
      programs = {
        keepassxc = {
          enable = true;
          autostart = true;
        };
      };
    };
}

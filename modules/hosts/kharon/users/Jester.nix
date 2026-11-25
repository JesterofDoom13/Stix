{ inputs, ... }: {
  flake.modules.nixos.kharon =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          Jester
          disko
          openlogi
          gaming
          printing
          umbriel-desktop
          (jovian "Jester" "umbriel")
        ];

      home-manager.users.Jester = { ... }:
        {
          imports =
            with inputs.self.modules.homeManager;
            [
              syncthing
              umbriel-desktop
            ];
          programs.xbox-cloud-gaming.enable = true;
          home.packages = [
            pkgs.moonlight-qt
            pkgs.pear-desktop
            pkgs.keepassxc
          ];
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
        };
    };
}

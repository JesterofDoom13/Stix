{
  flake.modules.homeManager.keepassxc = { pkgs, ... }:
    let
      gpgKeyId = "D29E85FF9B3B52B7";
      qbKeepassxc = pkgs.writeShellScript "qb-keepassxc" ''
        exec ${pkgs.python3.withPackages (ps: [ ps.pynacl ])}/bin/python \
          ${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-keepassxc "$@"
      '';
    in
    {
      programs = {
        keepassxc = {
          enable = true;
          autoStart = true;
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
        qutebrowser = {
          extraConfig = ''
            config.bind('<Space>p','spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='normal');
            config.bind("<Alt+p>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='insert');
            config.bind("<Alt+p>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='prompt');
            config.bind("<Space+Pu>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId} --username-only', mode='normal');
            config.bind("<Space+Pp>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId} --password-only', mode='normal');
          '';
        };
      };
    };
}


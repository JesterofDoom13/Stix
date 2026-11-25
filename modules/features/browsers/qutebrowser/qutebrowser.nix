{ inputs, ... }:
{
  flake.modules.homeManager.browsers = { pkgs, ... }:
    let
      gpgKeyId = "D29E85FF9B3B52B7";
      qbKeepassxc = pkgs.writeShellScript "qb-keepassxc" ''
        exec ${pkgs.python3.withPackages (ps: [ ps.pynacl ])}/bin/python \
          ${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-keepassxc "$@"
      '';
    in
    {
      # home.packages = [
      # ];
      programs.qutebrowser = {
        enable = true;
        extraConfig = ''
          #-- Visuals----------------------------------------------
          config.source('noctalia/colors.py')
          c.colors.webpage.darkmode.enabled = True
          c.colors.webpage.preferred_color_scheme = "dark"
          c.scrolling.bar = 'never'
          c.statusbar.show = 'in-mode'
          c.tabs.show = 'switching'
          c.auto_save.session = True
          c.content.cookies.accept = 'no-3rdparty'
          c.hints.uppercase = True
          c.colors.webpage.darkmode.enabled = True
          c.completion.shrink = True

          #-- Keybinds ---------------------------------------------

          config.bind("<Ctrl+s>", "config-cycle tabs.show always never")
          config.bind('tt', 'cmd-set-text -s :tab-select')
          config.bind('co', 'tab-only --prev')
          config.bind('<Space>td', 'config-cycle colors.webpage.darkmod.enabled')
          config.bind('<Space>sl', 'cmd-set-text -s :session-load -c ')
          config.bind('<Space>ss', 'cmd-set-text -s :session-save -o ')

          config.bind('<Space>p','spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='normal');
          config.bind("<Alt+p>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='insert');
          config.bind("<Alt+p>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId}', mode='prompt');
          config.bind("<Space+Pu>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId} --username-only', mode='normal');
          config.bind("<Space+Pp>",  'spawn --userscript ${qbKeepassxc} --key ${gpgKeyId} --password-only', mode='normal');
            
          #-- Adblcokingi ------------------------------------------
          c.content.blocking.method = "both"
          c.content.blocking.adblock.lists += [
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
          ]

          #-- Search enngines --------------------------------------
          c.url.searchengines = {
              "DEFAULT": "https://kagi.com/search?q={}",
              "nw": "https://wiki.nixos.org/index.php?search={}",
              "ns": "https://search.nixos.org/packages?channel=26.05&query={}",
              "gh": "https://github.com/search?q={}",
              "yt": "https://www.youtube.com/results?search_query={}",
              "hm": "https://home-manager-options.extranix.com/?query={}&release=master",
          }
          c.spellcheck.languages = ["en-US"]
        '';
      };
      xdg.dataFile."qutebrowser/greasemonkey" = {
        source = (inputs.self + "/assets/greasemonkey");
        recursive = true;
      };
    };
}

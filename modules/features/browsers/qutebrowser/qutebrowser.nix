{ inputs, self, ... }:
{
  flake.modules.homeManager.qutebrowser = { ... }:
    {
      imports = with self.modules.homeManager;
        [
          qutebrowser-keepassxc
        ];
      programs.qutebrowser = {
        enable = true;
        keyBindings = {
          normal = {
            "<Ctrl+s>" = "config-cycle tabs.show always never";
            "tt" = "cmd-set-text -s :tab-select";
            "co" = "tab-only --prev";
            "<Space>td" = "config-cycle colors.webpage.darkmode.enabled";
            "<Space>sl" = "cmd-set-text -s :session-load -c ";
            "<Space>ss" = "cmd-set-text -s :session-save -o ";

          };
        };
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

          #-- Adblcokingi ------------------------------------------
          c.content.blocking.method = "both"
          c.content.blocking.adblock.lists += [
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
          ]

          #-- Search enngines --------------------------------------
          c.url.searchengines = {
              "DEFAULT": "https://duckduckgo.com/?q={}",
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

{ inputs, ... }:
{
  flake.modules.homeManager.browsers = { ... }: {
    # home.packages = [
    #   pkgs.qutebrowser
    # ];
    programs.qutebrowser = {
      enable = true;
      extraConfig = ''
        config.source('noctalia/colors.py')
        c.scrolling.bar = 'never'
        c.statusbar.show = 'in-mode'
        c.tabs.show = 'switching'
        c.auto_save.session = True
        c.content.cookies.accept = 'no-3rdparty'
        c.hints.uppercase = True

      '';
    };
    xdg.dataFile."qutebrowser/greasemonkey" = {
      source = (inputs.self + "/assets/greasemonkey");
      recursive = true;
    };
  };
}





{ ... }:
{
  flake.modules.homeManager.browsers = { ... }: {
    # home.packages = [
    #   pkgs.qutebrowser
    # ];
    programs.qutebrowser = {
      enable = true;
      extraConfig = ''
        config.source('noctalia/colors.py')

      '';
    };
  };
}

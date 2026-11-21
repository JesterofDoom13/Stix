{ ... }:
{
  flake.modules.homeManager.browsers = { pkgs, ... }: {
    home.packages = [
      pkgs.qutebrowser
    ];
    #     programs.qutebrowser = {
    #   enable = true;
    # };
  };
}

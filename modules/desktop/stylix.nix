{ pkgs
, myStylix
, inputs
, ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = false;
    autoEnable = true;
    polarity = "dark";
    image = ../../assets/imgs/background/brown_city_planet_w.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${myStylix}.yaml";
    fonts = {
      monospace.name = "FiraCode Nerd Font";
      sizes = {
        desktop = 8;
        applications = 8;
        popups = 8;
        terminal = 8;
      };
    };
    targets = {
      zen-browser.profileNames = [ "default" ];
      noctalia-shell.enable = false;
      fish.enable = false;
    };
  };
}

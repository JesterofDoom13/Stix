{ inputs, system, ... }:
{
  imports = [
    inputs.nix-yazi-plugins.legacyPackages.${system}.homeManagerModules.default
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };

  programs.yazi.yaziPlugins = {
    enable = true;
    plugins = {
      ouch = {
        enable = true;
      };
      rich-preview = {
        enable = true;
      };
      glow = {
        enable = false;
      };
      chmod = {
        enable = true;
      };
      jump-to-char = {
        enable = true;
        keys.toggle.on = [ "F" ];
      };
      relative-motions = {
        enable = true;
        show_numbers = "relative_absolute";
        show_motion = true;
      };
    };
  };
}

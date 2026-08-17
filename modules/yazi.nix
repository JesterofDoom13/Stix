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
      rich-preview = {
        enable = true;
      };
      relative-motions = {
        enable = true;
        show_numbers = "relative_absolute";
        show_motion = true;
      };
      ouch = {
        enable = true;
      };
      jump-to-char = {
        enable = true;
        keys.toggle.on = [ "F" ];
      };
      glow = {
        enable = false;
      };
      chmod = {
        enable = true;
      };
    };
  };
}

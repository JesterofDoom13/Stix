{
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  ghostty-pkg = inputs.ghostty.packages.${system}.default;
  homeDir = config.home.homeDirectory;
in
{
  programs.ghostty = {
    enable = true;
    package = ghostty-pkg;
    settings = {
      # keybind = [ "global:super+semicolon=toggle_quick_terminal" ];
      quick-terminal-size = "72.5%,90%";
      window-decoration = "none";
      gtk-titlebar = false;
      clipboard-paste-protection = false;
      background-opacity = 0.85;
      background-blur = true;
      gtk-single-instance = true;
      alpha-blending = "native";
      font-size = 9;
      font-thicken = true;
      adjust-cell-height = -2;
      adjust-cell-width = "-20%";
      adjust-underline-position = 2;
      window-padding-x = 2;
      command = "${pkgs.fish}/bin/fish";
      confirm-close-surface = false;
      custom-shader = [
        "${homeDir}/.config/ghostty/shaders/cursor_tail.glsl"
        "${homeDir} /.config/ghostty/shaders/sonic_boom_cursor.glsl"
      ];
      # initial-window = false;
      # quit-after-last-window-closed = false;
    };
  };

  xdg.configFile = {
    "ghostty/shaders/sparks-from-fire.glsl".source = ../../assets/ghostty/shaders/sparks-from-fire.glsl;
    "ghostty/shaders/cursor_tail.glsl".source = ../../assets/ghostty/shaders/cursor_tail.glsl;
    "ghostty/shaders/sonic_boom_cursor.glsl".source =
      ../../assets/ghostty/shaders/sonic_boom_cursor.glsl;
  };
}

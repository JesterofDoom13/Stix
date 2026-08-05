{ pkgs
, inputs
, system
, ...
}:
let
  ghostty-pkg = inputs.ghostty.packages.${system}.default;
in
{
  programs.ghostty = {
    enable = true;
    package = ghostty-pkg;
    settings = {
      quick-terminal-size = "72.5%,90%";
      window-decoration = "none";
      gtk-titlebar = false;
      clipboard-paste-protection = false;
      background-opacity = 0.88;
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
      theme = "noctalia";
      # -- enable these if you want quick termial dropdown style ------
      # keybind = [ "global:super+semicolon=toggle_quick_terminal" ];
      # initial-window = false;
      # quit-after-last-window-closed = false;
    };
  };
}

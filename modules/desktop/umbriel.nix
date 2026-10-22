{ inputs, ... }: {
  imports = [ inputs.umbriel.homeModules.default ];
  programs.umbriel.enable = true;
  programs.umbriel.settings = {
    general.autostart = [ "noctalia" ];
    layout.gap = 5;
    input.keyboard.layout = "en";
    keybinds = {
      "Mod+Return" = "spawn:ghostty";
      "Mod+Q" = "window-close";
      "Mod+Spacebar" = "spawn:noctalia msg panel-toggle launcher";
    };
  };
}

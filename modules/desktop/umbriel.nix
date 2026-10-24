{ inputs, ... }: {
  imports = [ inputs.umbriel.homeModules.default ];
  programs.umbriel.enable = true;
  programs.umbriel.settings = {
    general.autostart = [ "noctalia" ];
    general.xwayland = true;
    layout.gap = 5;
    include.optional.files = [ "~/.config/umbriel/noctalia.toml" ];
    input.keyboard.layout = "us";
    input.keyboard.options = "caps:escape";
    output = {
      "Sony SONY AVSYSTEM 0x01010101" = {
        mode = "3840x2160@30";
        hdr = "on";
        scale = 1.75;
      };
    };
    keybinds = {
      # Apps
      "Mod+Semicolon" = "spawn:ghostty";
      "Mod+B" = "spawn:zen-beta";
      "Mod+E" = "spawn:pcmanfm-qt";
      "Mod+G" = "spawn:google-chrome";
      "Mod+Q" = "window-close";

      # Window management
      ## Resizing
      "Mod+Equal" = "window-modify-width-right:0.1";
      "Mod+Minus" = "window-modify-width-right:-0.1";
      "Mod+Shift+F" = "window-toggle-fullscreen";
      "Mod+F" = "window-toggle-maximize";
      "Mod+Alt+F" = "spawn:umbriel msg window-toggle-floating && umbriel msg window-center";
      "Mod+P" = "window-toggle-pinned";

      ## Moving 
      "Mod+H" = "window-focus-left";
      "Mod+L" = "window-focus-right";
      "Mod+K" = "window-focus-up";
      "Mod+J" = "window-focus-down";

      ## Shifting columns
      "Mod+Shift+H" = "column-move-left";
      "Mod+Shift+L" = "column-move-right";
      "Mod+C" = "column-center";
      "Mod+O" = "overview-toggle";

      # Misc
      "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+Slash" = "cheatsheet-toggle";
      "Mod+Shift+W" = "spawn:noctalia msg wallpaper-random";

      # Special Keys
      "XF86AudioRaiseVolume" = {
        action = "spawn:noctalia msg volume-up";
        allow_when_locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = "spawn:noctalia msg volume-down";
        allow_when_locked = true;
      };
      "XF86AudioMute" = {
        action = "spawn:noctalia msg volume-mute-toggle";
        allow_when_locked = true;
      };
      "XF86AudioMicMute" = {
        action = "spawn:noctalia msg microphone-mute-toggle";
        allow_when_locked = true;
      };
      "XF86MonBrightnessUp" = {
        action = "spawn:noctalia msg brightness-up 5";
        allow_when_locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = "spawn:noctalia msg brightness-down 5";
        allow_when_locked = true;
      };
      "XF86AudioNext" = {
        action = "spawn:noctalia msg media next";
        allow_when_locked = true;
      };
      "XF86AudioPause" = {
        action = "spawn:noctalia msg media toggle";
        allow_when_locked = true;
      };
      "XF86AudioPlay" = {
        action = "spawn:noctalia msg media toggle";
        allow_when_locked = true;
      };
      "XF86AudioPrev" = {
        action = "spawn:noctalia msg media previous";
        allow_when_locked = true;
      };
    };
  };
}

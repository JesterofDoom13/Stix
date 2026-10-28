{ inputs, ... }: {
  imports = [ inputs.umbriel.homeModules.default ];
  programs.umbriel.enable = true;
  programs.umbriel.settings = {
    environment = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      SDL_VIDEODRIVER = "wayland";
    };
    general.autostart = [ "noctalia" ];
    general.xwayland = true;
    layout.gap = 5;
    appearance = {
      blur = {
        enabled = true;
      };
    };
    include.optional.files = [
      "~/.config/umbriel/noctalia.toml"
      "~/.config/umbriel/outputs.toml"
    ];
    input = {
      middle_click_paste = true;
      cursor = {
        theme = "Adawaita";
        size = 36;
        hide_when_typing = true;
      };
      keyboard = {
        layout = "us";
        options = "caps:escape";
      };
    };
    output = {
      eDP-1 = {
        hdr = "auto";
        transform = "270";
        workspaces = "dynamic";
      };
      "Sony SONY AVSYSTEM 0x01010101" = {
        mode = "3840x2160@30";
        hdr = "auto";
        scale = 2.00;
        workspaces = "dynamic";
      };
    };
    keybinds = {
      # Apps
      "Mod+Semicolon" = "spawn:ghostty";
      "Mod+B" = "spawn:zen-beta";
      "Mod+E" = "spawn:pcmanfm-qt";
      "Mod+G" = "spawn:google-chrome";
      "Mod+Shift+G" = "spawn:noctalia msg notification-show 'Launching Gamescope...' && start-gamescope-session";

      # Window management
      "Mod+Q" = "window-close";

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
      "Mod+K" = "window-focus-or-workspace-up";
      "Mod+J" = "window-focus-or-workspace-down";
      "Alt+Tab" = "window-focus-next";
      "Alt+Shift+Tab" = "window-focus-previous";

      "Mod+Shift+1" = "window-move-to-workspace:1";
      "Mod+Shift+2" = "window-move-to-workspace:2";
      "Mod+Shift+3" = "window-move-to-workspace:3";
      "Mod+Shift+4" = "window-move-to-workspace:4";
      "Mod+Shift+5" = "window-move-to-workspace:5";
      "Mod+Shift+6" = "window-move-to-workspace:6";
      "Mod+Shift+7" = "window-move-to-workspace:7";
      "Mod+Shift+8" = "window-move-to-workspace:8";
      "Mod+Shift+9" = "window-move-to-workspace:9";
      "Mod+Shift+J" = "window-move-or-workspace-down";
      "Mod+Shift+K" = "window-move-or-workspace-up";

      ## Shifting columns
      "Mod+Shift+H" = "column-move-left";
      "Mod+Shift+L" = "column-move-right";
      "Mod+C" = "column-center";
      "Mod+O" = "overview-toggle";

      # Workspaces
      "Mod+Ctrl+J" = "workspace-next";
      "Mod+Ctrl+K" = "workspace-previous";
      "Mod+1" = "workspace-switch:1";
      "Mod+2" = "workspace-switch:2";
      "Mod+3" = "workspace-switch:3";
      "Mod+4" = "workspace-switch:4";
      "Mod+5" = "workspace-switch:5";
      "Mod+6" = "workspace-switch:6";
      "Mod+7" = "workspace-switch:7";
      "Mod+8" = "workspace-switch:8";
      "Mod+9" = "workspace-switch:9";
      "Mod+Tab" = "output-focus-next";
      "Mod+Shift+Tab" = "spawn:umbriel msg output-toggle:eDP-1";

      # Misc
      # "Esc+1" = "spawn:umbriel msg ouput-toggle:eDP-1"; # Can't figure out what chord I want for this yet.
      "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+Slash" = "cheatsheet-toggle";
      "Mod+Shift+W" = "spawn:noctalia msg wallpaper-random"; # Change wallpaper when I want a new theme

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

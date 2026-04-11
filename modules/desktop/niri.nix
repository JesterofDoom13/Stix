{ pkgs, inputs, ... }:
let
  #TODO: Have noctalia display notification when launching into gamescope
  gamescope-json = ''
    '{
      "title": "Steam",
      "body": "Launching Gamescope..."
    }'
  '';

  gamescope-launch = pkgs.writeShellScriptBin "gamescope-launch" ''
    noctalia-shell ipc call toast send ${gamescope-json}
    start-gamescope-session
  '';
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
  terminal = "${pkgs.ghostty}/bin/ghostty";
  inherit (pkgs.stdenv.hostPlatform) system;
  browser = "${inputs.zen-browser.packages.${system}.beta}/bin/zen-beta";

in
{
  programs = {
    fuzzel.enable = true;
  };

  home.packages = with pkgs; [
    gamescope-launch
    swaybg
    swaylock
    kanshi
    niriswitcher
    wl-clipboard-rs
  ];

  # Kanshi config
  xdg.configFile."kanshi/config".text = ''
    profile deck_only {
      output eDP-1 enable scale 1.25 transform 270
      }

      profile external {
      output eDP-1 disable
      output DP-1 enable scale 1.0
      }
  '';

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "${pkgs.kanshi}/bin/kanshi" ]; }
      { command = [ "${pkgs.niriswitcher}/bin/niriswitcher" ]; }
      {
        command = [
          "sh"
          "-c"
          "export XDG_MENU_PREFIX=plasma- && kbuildsycoca6 --noincremental"
        ];
      }
    ];

    hotkey-overlay.skip-at-startup = true;

    layout = {
      focus-ring.enable = false;
      border.enable = false;
    };

    input = {
      keyboard.xkb.options = "caps:swapescape";
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true; # disable while typing
      };
    };

    binds = {

      # Window details (useful for finding app-ids)
      "Mod+Backslash" = {
        action.spawn = [ "niri-window-details" ];
      };

      # Peekaboo
      "Mod+P" = {
        action.spawn = [ "niri-peekaboo" ];
      };

      # Workspace helper replacing default workspace binds
      "Mod+1" = {
        action.spawn = [
          "niri-workspace-helper"
          "1"
        ];
      };
      "Mod+2" = {
        action.spawn = [
          "niri-workspace-helper"
          "2"
        ];
      };
      "Mod+3" = {
        action.spawn = [
          "niri-workspace-helper"
          "3"
        ];
      };
      "Mod+4" = {
        action.spawn = [
          "niri-workspace-helper"
          "4"
        ];
      };
      "Mod+5" = {
        action.spawn = [
          "niri-workspace-helper"
          "5"
        ];
      };

      # Show keybind-cheatsheet
      "Mod+Slash" = {
        action.spawn = noctalia "plugin:keybind-cheatsheet toggle";
        hotkey-overlay.title = "Noctalia Cheatsheet";
      };

      # Show kde-connect
      "Mod+Period" = {
        action.spawn = noctalia "plugin:kde-connect toggle";
        hotkey-overlay.title = "toggle kde-connect";
      };

      #nirswitcherctl
      "Alt+Tab" = {
        action.spawn = [
          "niriswitcherctl"
          "show"
          "--window"
        ];
      };
      "Alt+Shift+Tab" = {
        action.spawn = [
          "niriswitcherctl"
          "show"
          "--window"
        ];
      };
      "Alt+Grave" = {
        action.spawn = [
          "niriswitcherctl"
          "show"
          "--workspace"
        ];
      };
      "Alt+Shift+Grave" = {
        action.spawn = [
          "niriswitcherctl"
          "show"
          "--works"
        ];
      };

      # Session
      "Mod+Shift+E" = {
        action.quit = { };
      };
      "Mod+Shift+P" = {
        action.spawn = noctalia "sessionMenu toggle";
      };
      "Mod+Shift+G" = {
        action.spawn = [ "gamescope-launch" ];
      };

      # Apps
      "Mod+T" = {
        action.spawn = [ terminal ];
        hotkey-overlay.title = "Ghostty Terminal";
      };
      "Mod+semicolon" = {
        action.spawn = [ terminal ];
        hotkey-overlay.title = "Ghostty Terminal";
      };
      "Mod+B" = {
        action.spawn = [ browser ];
      };
      "Mod+G" = {
        action.spawn = [ "${pkgs.google-chrome}/bin/google-chrome" ];
      };
      "Mod+Space" = {
        action.spawn = noctalia "launcher toggle";
      };

      # Noctalia controls
      "Mod+N" = {
        action.spawn = noctalia "controlCenter toggle";
      };
      "XF86AudioRaiseVolume" = {
        action.spawn = noctalia "volume increase";
      };
      "XF86AudioLowerVolume" = {
        action.spawn = noctalia "volume decrease";
      };
      "XF86AudioMute" = {
        action.spawn = noctalia "volume muteOutput";
      };
      "XF86MonBrightnessUp" = {
        action.spawn = noctalia "brightness increase";
      };
      "XF86MonBrightnessDown" = {
        action.spawn = noctalia "brightness decrease";
      };

      # Screenshots
      "Mod+S" = {
        action.screenshot = { };
      };
      "Ctrl+Print" = {
        action.screenshot-screen = { };
      };
      "Alt+Print" = {
        action.screenshot-window = { };
      };

      # Window management
      "Mod+Q" = {
        action.close-window = { };
      };
      "Mod+F" = {
        action.maximize-column = { };
      };
      "Mod+Shift+F" = {
        action.fullscreen-window = { };
      };
      "Mod+C" = {
        action.center-column = { };
      };

      # Focus
      "Mod+H" = {
        action.focus-column-left = { };
      };
      "Mod+L" = {
        action.focus-column-right = { };
      };
      "Mod+J" = {
        action.focus-window-down = { };
      };
      "Mod+K" = {
        action.focus-window-up = { };
      };
      "Mod+Left" = {
        action.focus-column-left = { };
      };
      "Mod+Right" = {
        action.focus-column-right = { };
      };
      "Mod+Down" = {
        action.focus-window-down = { };
      };
      "Mod+Up" = {
        action.focus-window-up = { };
      };

      # Move windows
      "Mod+Shift+H" = {
        action.move-column-left = { };
      };
      "Mod+Shift+L" = {
        action.move-column-right = { };
      };
      "Mod+Shift+J" = {
        action.move-window-down = { };
      };
      "Mod+Shift+K" = {
        action.move-window-up = { };
      };

      # Workspaces
      "Mod+Ctrl+J" = {
        action.focus-workspace-down = { };
      };
      "Mod+Ctrl+K" = {
        action.focus-workspace-up = { };
      };
      # "Mod+1" = { action.focus-workspace = 1; };
      # "Mod+2" = { action.focus-workspace = 2; };
      # "Mod+3" = { action.focus-workspace = 3; };
      # "Mod+4" = { action.focus-workspace = 4; };
      # "Mod+5" = { action.focus-workspace = 5; };
      "Mod+Shift+1" = {
        action.move-column-to-workspace = 1;
      };
      "Mod+Shift+2" = {
        action.move-column-to-workspace = 2;
      };
      "Mod+Shift+3" = {
        action.move-column-to-workspace = 3;
      };
      "Mod+Shift+4" = {
        action.move-column-to-workspace = 4;
      };
      "Mod+Shift+5" = {
        action.move-column-to-workspace = 5;
      };

      # Column sizing
      "Mod+Minus" = {
        action.set-column-width = "-10%";
      };
      "Mod+Equal" = {
        action.set-column-width = "+10%";
      };
      "Mod+Shift+Minus" = {
        action.set-window-height = "-10%";
      };
      "Mod+Shift+Equal" = {
        action.set-window-height = "+10%";
      };

      # Overview
      "Mod+O" = {
        action.toggle-overview = { };
      };
    };
  };
}

{ inputs
, pkgs
, config
, lib
, ...
}:
let
  # Update noctalia before every build. sn = sync noctalia
  sn = pkgs.writeShellScriptBin "sn" ''
    #!/bin/bash
    set -e
    CONFIG_DIR="${config.programs.nh.flake}";
    OUTPUT="$CONFIG_DIR/assets/noctalias-settings.json"
    echo "Syncing noctalia settings..."
    noctalia-shell ipc call state all | ${pkgs.jq}/bin/jq '.settings' > "$OUTPUT"
    echo "Saved to $OUTPUT"
  '';
  # Now use those settings
  settingsFile = ../../assets/noctalias-settings.json;
  savedSettings =
    if builtins.pathExists settingsFile then
      builtins.fromJSON (builtins.readFile settingsFile)
    else
      { };
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    package = (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override { calendarSupport = true; });
    settings = lib.recursiveUpdate
      {
        settingsVersion = 59;
        bar = {
          barType = "floating";
          position = "top";
          monitors = [

          ];
          density = "mini";
          showOutline = false;
          showCapsule = true;
          capsuleOpacity = 0.26;
          capsuleColorKey = "primary";
          widgetSpacing = 5;
          contentPadding = 30;
          fontScale = 1.3;
          enableExclusionZoneInset = false;
          backgroundOpacity = 1;
          useSeparateOpacity = true;
          marginVertical = 4;
          marginHorizontal = 4;
          frameThickness = 8;
          frameRadius = 13;
          outerCorners = true;
          hideOnOverview = true;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;
          widgets = {
            left = [
              {
                compactMode = true;
                diskPath = "/";
                iconColor = "none";
                id = "SystemMonitor";
                showCpuCores = true;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = true;
                showDiskUsage = true;
                showDiskUsageAsPercent = true;
                showGpuTemp = false;
                showLoadAverage = true;
                showMemoryAsPercent = true;
                showMemoryUsage = true;
                showNetworkStats = true;
                showSwapUsage = false;
                textColor = "none";
                useMonospaceFont = true;
                usePadding = false;
              }
              {
                defaultSettings = {
                  compactMode = false;
                  defaultPeerAction = "copy-ip";
                  hideDisconnected = false;
                  hideMullvadExitNodes = true;
                  pingCount = 5;
                  refreshInterval = 5000;
                  showIpAddress = true;
                  showPeerCount = true;
                  sshUsername = "";
                  taildropDownloadDir = "~/Downloads";
                  taildropEnabled = true;
                  taildropReceiveMode = "operator";
                  terminalCommand = "";
                };
                id = "plugin:tailscale";
              }
              {
                defaultSettings = {
                  apiKey = "";
                  apiUrl = "";
                  configPath = "";
                  enabled = true;
                  folderIds = [

                  ];
                  pollIntervalMs = 10000;
                  verifyTls = false;
                };
                id = "plugin:syncthing-status";
              }
            ];
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "none";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = false;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
            ];
            right = [
              {
                blacklist = [

                ];
                chevronColor = "none";
                colorizeIcons = true;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [
                  "indicator-solaar"
                ];
              }
              {
                iconColor = "none";
                id = "PowerProfile";
              }
              {
                deviceNativePath = "BAT1";
                displayMode = "graphic";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                applyToAllMonitors = false;
                displayMode = "onhover";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                defaultSettings = { };
                id = "plugin:kde-connect";
              }
              {
                defaultSettings = {
                  autoHeight = true;
                  cheatsheetData = [

                  ];
                  columnCount = 3;
                  detectedCompositor = "";
                  hyprlandConfigPath = "~/.config/hypr/hyprland.conf";
                  modKeyVariable = "$mod";
                  niriConfigPath = "~/.config/niri/config.kdl";
                  windowHeight = 0;
                  windowWidth = 1400;
                };
                id = "plugin:keybind-cheatsheet";
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd ddMMMyy";
                formatVertical = "HH mm ss - ddd - dd MMM yy";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
            ];
          };
          mouseWheelAction = "volume";
          reverseScroll = false;
          mouseWheelWrap = true;
          middleClickAction = "controlCenter";
          middleClickFollowMouse = true;
          middleClickCommand = "";
          rightClickAction = "settings";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [

          ];
        };
        general = {
          avatarImage = "/home/Jester/.face";
          dimmerOpacity = 0.2;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 0.5;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockScreenAnimations = false;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "hh\\nmm";
          passwordChars = false;
          lockScreenMonitors = [

          ];
          lockScreenBlur = 0;
          lockScreenTint = 0;
          keybinds = {
            keyUp = [
              "Up"
            ];
            keyDown = [
              "Down"
            ];
            keyLeft = [
              "Left"
            ];
            keyRight = [
              "Right"
            ];
            keyEnter = [
              "Return"
              "Enter"
            ];
            keyEscape = [
              "Esc"
            ];
            keyRemove = [
              "Del"
            ];
          };
          reverseScroll = false;
          smoothScrollEnabled = true;
        };
        ui = {
          fontDefault = "FiraCode Nerd Font Ret";
          fontFixed = "FiraCode Nerd Font Mono Med";
          fontDefaultScale = 0.84;
          fontFixedScale = 0.89;
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = true;
          boxBorderEnabled = false;
          panelBackgroundOpacity = 0.93;
          translucentWidgets = false;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = false;
        };
        location = {
          name = "Denver, CO";
          weatherEnabled = true;
          weatherShowEffects = true;
          weatherTaliaMascotAlways = false;
          useFahrenheit = true;
          use12hourFormat = true;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
          autoLocate = false;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "/home/Jester/Pictures/Wallpapers";
          monitorDirectories = [

          ];
          enableMultiMonitorDirectories = false;
          showHiddenFiles = false;
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          linkLightAndDarkWallpapers = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = true;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = [
            "fade"
            "disc"
            "stripes"
            "wipe"
            "pixelate"
            "honeycomb"
          ];
          skipStartupTransition = false;
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useOriginalImages = false;
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
          favorites = [

          ];
        };
        appLauncher = {
          enableClipboardHistory = false;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          enableClipboardSmartIcons = true;
          enableClipboardChips = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [
            "google-chrome"
          ];
          sortByMostUsed = true;
          terminalCommand = "ghostty -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
          overviewLayer = false;
          density = "comfortable";
        };
        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "WallpaperSelector";
              }
              {
                id = "NoctaliaPerformance";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 5;
          enableDgpuMonitoring = false;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };
        noctaliaPerformance = {
          disableWallpaper = false;
          disableDesktopWidgets = false;
        };
        dock = {
          enabled = true;
          position = "bottom";
          displayMode = "always_visible";
          dockType = "floating";
          backgroundOpacity = 0.29;
          floatingRatio = 0.27;
          size = 0.75;
          onlySameOutput = true;
          monitors = [

          ];
          pinnedApps = [
            "google-chrome"
          ];
          colorizeIcons = false;
          showLauncherIcon = true;
          launcherPosition = "start";
          launcherUseDistroLogo = true;
          launcherIcon = "";
          launcherIconColor = "secondary";
          pinnedStatic = true;
          inactiveIndicators = true;
          groupApps = true;
          groupContextMenuMode = "extended";
          groupClickAction = "cycle";
          groupIndicatorStyle = "dots";
          deadOpacity = 0.62;
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = true;
          indicatorThickness = 6;
          indicatorColor = "primary";
          indicatorOpacity = 0.53;
        };
        network = {
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "ethernet";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };
        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "4";
            }
            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "5";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "6";
            }
            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "7";
            }
            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };
        notifications = {
          enabled = true;
          enableMarkdown = true;
          density = "default";
          monitors = [

          ];
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          clearDismissed = true;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = true;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,chromium,edge";
          };
          enableMediaToast = true;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [
            0
            1
            2
            3
          ];
          monitors = [

          ];
        };
        audio = {
          volumeStep = 5;
          volumeOverdrive = true;
          spectrumFrameRate = 30;
          visualizerType = "linear";
          spectrumMirrored = true;
          mprisBlacklist = [

          ];
          preferredPlayer = "";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
        };
        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = false;
          backlightDeviceMappings = [

          ];
        };
        colorSchemes = {
          useWallpaperColors = true;
          predefinedScheme = "Monochrome";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "vibrant";
          monitorForColors = "";
          syncGsettings = true;
        };
        templates = {
          activeTemplates = [
            {
              enabled = true;
              id = "niri";
            }
            {
              enabled = true;
              id = "zenBrowser";
            }
            {
              enabled = true;
              id = "yazi";
            }
            {
              enabled = true;
              id = "ghostty";
            }
            {
              enabled = true;
              id = "btop";
            }
            {
              enabled = true;
              id = "qt";
            }
            {
              enabled = true;
              id = "gtk";
            }
            {
              enabled = true;
              id = "discord";
            }
            {
              enabled = true;
              id = "zathura";
            }
            {
              enabled = true;
              id = "steam";
            }
          ];
          enableUserTheming = false;
        };
        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };
        hooks = {
          enabled = true;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
          colorGeneration = "";
        };
        plugins = {
          autoUpdate = false;
          notifyUpdates = true;
        };
        idle = {
          enabled = true;
          screenOffTimeout = 300;
          lockTimeout = 660;
          suspendTimeout = 1800;
          fadeDuration = 5;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
        };
        desktopWidgets = {
          enabled = false;
          overviewEnabled = true;
          gridSnap = false;
          gridSnapScale = false;
          monitorWidgets = [

          ];
        };
      }
      savedSettings;
    user-templates = {
      templates = {
        nvim-colors = {
          input_path = "~/.config/nvim/lua/templates/matugen-template.lua";
          output_path = "~/.config/nvim/lua/matugen.lua";
          post_hook = "pkill -SIGUSR1 nvim";
        };
        tmux-colors = {
          input_path = "~/.config/tmux/templates/colors-template.conf";
          output_path = "~/.config/tmux/noctalia-colors.conf";
          post_hook = "tmux source-file ~/.config/tmux/noctalia-colors.conf";
        };
        fish-colors = {
          input_path = "~/.config/fish/templates/colors-template.fish";
          output_path = "~/.config/fish/noctalia-colors.fish";
          # post_hook = "tmux list-panes -a -F '#{pane_id}' | xargs -I{} tmux send-keys -t {} 'source ~/.config/fish/noctalia-colors.fish' Enter";
          post_hook = "fish -c ~/.config/fish/noctalia-colors.fish";
        };
        user-templates.templates.dolphin = {
          input_path = "~/.config/nvim/templates/kdeglobals.template"; # Or wherever you keep templates
          output_path = "~/.config/kdeglobals";
          # Signal Qt apps to refresh if possible
          post_hook = "dbus-send --type=signal /KWin org.kde.KWin.reloadConfig";
        };
      };
    };
  };
  home = {

    packages = with pkgs; [
      sn
      jq
    ];
    file = {
      # Wallpaper config
      ".cache/noctalia/wallpapers.json".text = builtins.toJSON {
        defaultWallpaper = "${homeDir}/Stix/assets/imgs/background/brown_city_planet_w.jpg";
      };
      # tmux noctalia wallpaper template
      ".config/tmux/templates/colors-template.conf".text = ''
        # Status bar background and foreground
        set -g status-style "bg={{colors.surface.default.hex}},fg={{colors.on_surface.default.hex}}"
        # Window selection colors
        set -g window-status-current-style "bg={{colors.primary.default.hex}},fg={{colors.on_primary.default.hex}},bold"
        set -g window-status-style "fg={{colors.surface.default.hex}},bg={{colors.on_surface_variant.default.hex}}"
        # Pane borders
        set -g pane-border-style "fg={{colors.outline.default.hex}}"
        set -g pane-active-border-style "fg={{colors.primary.default.hex}}"
        # Message command line
        set -g message-style "bg={{colors.secondary_container.default.hex}},fg={{colors.on_secondary_container.default.hex}}"
      '';
      # fish noctalia wallpaper template
      ".config/fish/templates/colors-template.fish" = {
        text = ''
          #!/usr/bin/env fish
          set -U fish_color_normal {{colors.on_surface.default.hex_stripped}}
          set -U fish_color_command {{colors.primary.default.hex_stripped}} --bold
          set -U fish_color_keyword {{colors.tertiary.default.hex_stripped}}
          set -U fish_color_quote {{colors.secondary.default.hex_stripped}}
          set -U fish_color_redirection {{colors.primary_container.default.hex_stripped}}
          set -U fish_color_end {{colors.on_surface_variant.default.hex_stripped}}
          set -U fish_color_error {{colors.error.default.hex_stripped}}
          set -U fish_color_param {{colors.on_surface.default.hex_stripped}}
          set -U fish_color_comment {{colors.outline.default.hex_stripped}}
          set -U fish_color_selection --background={{colors.surface_container_high.default.hex_stripped}}
          set -U fish_color_search_match --background={{colors.surface_container_highest.default.hex_stripped}}
          set -U fish_color_operator {{colors.primary.default.hex_stripped}}
          set -U fish_color_escape {{colors.secondary.default.hex_stripped}}
          set -U fish_color_autosuggestion {{colors.outline.default.hex_stripped}}

          # Pager colors (completion menu)
          set -U fish_pager_color_progress {{colors.on_surface_variant.default.hex_stripped}}
          set -U fish_pager_color_prefix {{colors.primary.default.hex_stripped}} --bold --underline
          set -U fish_pager_color_completion {{colors.on_surface.default.hex_stripped}}
          set -U fish_pager_color_description {{colors.outline.default.hex_stripped}}
          source ~/.config/fish/config.fish

        '';
        executable = true;
      };
      # ".config/kdeglobals.template".text = ''
      #   [General]
      #   ColorScheme=Noctalia
      #   Name=Noctalia
      #
      #   [Colors:Window]
      #   BackgroundNormal={{colors.surface.default.hex}}
      #   ForegroundNormal={{colors.on_surface.default.hex}}
      #
      #   [Colors:View]
      #   BackgroundNormal={{colors.surface.default.hex}}
      #   ForegroundNormal={{colors.on_surface.default.hex}}
      #   BackgroundAlternate={{colors.surface_container.default.hex}}
      #
      #   [Colors:Selection]
      #   BackgroundNormal={{colors.primary.default.hex}}
      #   ForegroundNormal={{colors.on_primary.default.hex}}
      # '';
    };
  };

  # Launch noctalia on niri startup
  programs.niri.settings.spawn-at-startup = [
    { command = [ "noctalia-shell" ]; }
  ];
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xbox-cloud-gaming;

  xboxCloudEdge = pkgs.writeShellScriptBin "xbox-cloud-gaming" ''
    # Steam injects LD_PRELOAD / LD_LIBRARY_PATH / STEAM_RUNTIME* into every
    # non-Steam shortcut's environment for Proton/native game compatibility.
    # Those collide with Edge's own bundled libs and crash it almost
    # immediately, so strip them before launching.
    for var in $(env | ${pkgs.gnugrep}/bin/grep -oE '^(LD_PRELOAD|LD_LIBRARY_PATH|LD_AUDIT|STEAM_RUNTIME[A-Z_]*)=' | ${pkgs.coreutils}/bin/cut -d= -f1); do
      unset "$var"
    done

    exec ${cfg.package}/bin/microsoft-edge \
      --kiosk "${cfg.url}" \
      --edge-kiosk-type=fullscreen \
      --no-first-run \
      --disable-infobars \
      --disable-session-crashed-bubble \
      --overscroll-history-navigation=0 \
      --autoplay-policy=no-user-gesture-required \
      --user-data-dir="${cfg.profileDir}" \
      --class=${cfg.windowClass} \
      ${escapeShellArgs cfg.extraFlags} \
      "$@"
  '';

  addSteamShortcutScript = pkgs.writeText "add-xbox-shortcut.py" ''
    import vdf, os, glob, binascii, sys

    exe = "\"${xboxCloudEdge}/bin/xbox-cloud-gaming\""
    name = "${cfg.steamShortcutName}"
    start_dir = "\"${xboxCloudEdge}/bin\""

    def gen_appid(exe, name):
        crc = binascii.crc32((exe + name).encode("utf-8")) & 0xffffffff
        unsigned = crc | 0x80000000
        # the vdf library packs appid with struct's signed 'i' format, so
        # convert the unsigned 32-bit value to its signed two's-complement form
        return unsigned - 0x100000000 if unsigned >= 0x80000000 else unsigned

    userdata_glob = os.path.expanduser("~/.steam/steam/userdata/*/config")
    dirs = glob.glob(userdata_glob)
    if not dirs:
        print("add-xbox-cloud-steam-shortcut: no Steam userdata dir found yet, skipping "
              "(log into Steam once, then re-run: add-xbox-cloud-steam-shortcut)")
        sys.exit(0)

    for cfgdir in dirs:
        path = os.path.join(cfgdir, "shortcuts.vdf")
        if os.path.exists(path):
            with open(path, "rb") as f:
                data = vdf.binary_loads(f.read())
        else:
            data = {"shortcuts": {}}

        shortcuts = data.setdefault("shortcuts", {})
        existing = next((v for v in shortcuts.values() if v.get("AppName") == name), None)

        if existing is not None:
            # Keep the exe/start dir in sync with the current Nix store path
            # (it changes on every rebuild), everything else left alone.
            existing["Exe"] = exe
            existing["StartDir"] = start_dir
        else:
            idx = str(len(shortcuts))
            shortcuts[idx] = {
                "appid": gen_appid(exe, name),
                "AppName": name,
                "Exe": exe,
                "StartDir": start_dir,
                "icon": "${cfg.iconPath}",
                "ShortcutPath": "",
                "LaunchOptions": "",
                "IsHidden": 0,
                "AllowDesktopConfig": 1,
                "AllowOverlay": 1,
                "OpenVR": 0,
                "Devkit": 0,
                "DevkitGameID": "",
                "DevkitOverrideAppID": 0,
                "LastPlayTime": 0,
                "tags": {},
            }

        with open(path, "wb") as f:
            f.write(vdf.binary_dumps(data))
        print(f"add-xbox-cloud-steam-shortcut: synced '{name}' in {path}")
  '';

  addSteamShortcut = pkgs.writeShellApplication {
    name = "add-xbox-cloud-steam-shortcut";
    runtimeInputs = [ (pkgs.python3.withPackages (ps: [ ps.vdf ])) ];
    text = ''
      if pgrep -x steam >/dev/null 2>&1; then
        echo "add-xbox-cloud-steam-shortcut: Steam is running - it will overwrite" >&2
        echo "shortcuts.vdf on exit. Close Steam, re-run this, then start Steam." >&2
        exit 1
      fi
      python3 ${addSteamShortcutScript}
    '';
  };
in
{
  options.programs.xbox-cloud-gaming = {
    enable = mkEnableOption "Xbox Cloud Gaming via a kiosk-mode Edge browser, wired into Steam";

    package = mkOption {
      type = types.package;
      default = pkgs.microsoft-edge;
      defaultText = literalExpression "pkgs.microsoft-edge";
      description = "Edge package to use.";
    };

    url = mkOption {
      type = types.str;
      default = "https://www.xbox.com/play";
      description = "URL Edge opens in kiosk mode.";
    };

    windowClass = mkOption {
      type = types.str;
      default = "XboxCloudGaming";
      description = "WM_CLASS for the kiosk window, useful for niri window rules.";
    };

    profileDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.local/share/microsoft-edge-xcloud";
      description = "Dedicated Edge profile dir, kept separate from your normal Edge profile.";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--force-dark-mode" ];
      description = "Extra flags appended to the Edge launch command.";
    };

    iconPath = mkOption {
      type = types.str;
      default = "";
      description = "Optional absolute path to a .png/.ico for the Steam shortcut tile.";
    };

    autoAddSteamShortcut = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Run the shortcut-sync script as part of `home-manager switch`
        (via home.activation). Steam must be closed for this to take effect;
        if it's running, the activation step warns and skips instead of failing
        the whole switch.
      '';
    };

    steamShortcutName = mkOption {
      type = types.str;
      default = "Xbox Cloud Gaming";
      description = "Display name of the non-Steam shortcut entry.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package xboxCloudEdge addSteamShortcut ];

    home.activation.xboxCloudSteamShortcut = mkIf cfg.autoAddSteamShortcut (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ${pkgs.procps}/bin/pgrep -x steam >/dev/null 2>&1; then
          echo "xbox-cloud-gaming: Steam is running, skipping shortcut sync." \
               "Run 'add-xbox-cloud-steam-shortcut' by hand after closing Steam." >&2
        else
          $DRY_RUN_CMD ${pkgs.python3.withPackages (ps: [ ps.vdf ])}/bin/python3 \
            ${addSteamShortcutScript} || true
        fi
      ''
    );
  };
}

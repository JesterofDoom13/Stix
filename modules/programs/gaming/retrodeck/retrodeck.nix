{ inputs, ... }:
{
  flake.modules.homeManager.retrodeck = { config, ... }:
    let
      mkFolder = inputs.self.lib.syncthing.mkFolder config;
      home = config.home.homeDirectory;
      retrodeck = "${home}/retrodeck";
      saves = "${retrodeck}/saves";
    in
    {
      imports = [ inputs.self.modules.homeManager.flatpak ];
      services.flatpak.packages = [
        "net.retrodeck.retrodeck"
        "com.github.tchx84.Flatseal"
      ];
      services.syncthing.settings.folders = {
        #-- All the roms ------------------------------------------------------
        "roms" = mkFolder "${retrodeck}/roms" { };

        # -- Save folders ------------------------------------------------------
        "mame-saves" = mkFolder "${saves}/mame-sa" { };
        "duckstation-saves" = mkFolder "${saves}/psx/duckstation" { };
        "pcsx2-saves" = mkFolder "${saves}/ps2/pcsx2" { };
        "rpcs3-saves" = mkFolder "${saves}/ps3/rpcs3" { };
        "ppsspp-saves" = mkFolder "${saves}/PSP/PPSSPP-SA" { };
        "dolphin-gc-saves" = mkFolder "${saves}/gc/dolphin" { };
        "dolphin-saves" = mkFolder "${saves}/wii/dolphin" { };
        "primehack-gc-saves" = mkFolder "${saves}/gc/primehack" { };
        "primehack-saves" = mkFolder "${saves}/wii/primehack" { };
        "retroarch-ps2-saves" = mkFolder "${saves}/ps2/retroarch-core" { };
        "gba-saves" = mkFolder "${saves}/gba" { };
        "snes-saves" = mkFolder "${saves}/snes" { };
        "n64-saves" = mkFolder "${saves}/n64" { };
        "azahar-saves" = mkFolder "${saves}/n3ds/azahar" { };
        "cemu-saves" = mkFolder "${saves}/wiiu/cemu" { };
        "melonds-saves" = mkFolder "${saves}/nds/melonds" { };
        "vita3k-saves" = mkFolder "${saves}/psvita/vita3k" { };
        "xemu-saves" = mkFolder "${saves}/xbox/xemu" { };
        "ruffle-saves" = mkFolder "${saves}/flash/ruffle" { };

        #-- States and configs -------------------------------------------------
        "retrodeck-states" = mkFolder "${retrodeck}/states" { };
        "retoarch-saves" = mkFolder "${home}/.var/app/org.libretro.RetroArch/config/retroarch" {
          ignorePatterns = [ "// DO NOT IGNORE" "!/states" "!/saves" "// IGNORE" "*" ".DS_Store" ];
        };
      };
    };
}


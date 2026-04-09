{ config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  emuBase = "${homeDir}/Emulation";
in
{
  home.packages = [ pkgs.syncthing ];

  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      gui.address = "127.0.0.1:8384";
      devices = {
        "proxmox-syncthing" = {
          id = "OQXMPN3-3UISNNK-UL2FIJI-ZQQTRUC-ISUBUKO-SVWGF7R-A4SXXUA-I4BEVAJ";
          name = "Proxmox Syncthing";
        };
      };
      folders = {
        "kando" = {
          path = "${homeDir}/.config/kando";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "orca-slicer" = {
          path = "${homeDir}/.config/OrcaSlicer";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "mame-saves" = {
          path = "${homeDir}/.mame";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
          ignorePatterns = "// DO NOT IGNORE\n!/nvram\n!/sta\n// IGNORE\n*\n.DS_Store";
        };
        "flycast-saves" = {
          path = "${emuBase}/saves/flycast/saves";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "duckstation-saves" = {
          path = "${emuBase}/saves/duckstation/saves";
          devices = [ "proxmox-syncthing" ];
        };
        "retroarch-saves" = {
          path = "${homeDir}/.var/app/org.libretro.RetroArch/config/retroarch";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
          ignorePatterns = "// DO NOT IGNORE\n!/states\n!/saves\n// IGNORE\n*\n.DS_Store";
        };
        "ryujinx-saves" = {
          path = "${homeDir}/.config/Ryujinx/bis";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "rpcs3-saves" = {
          path = "${emuBase}/saves/rpcs3/saves";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "dolphin-saves" = {
          path = "${homeDir}/.local/share/dolphin-emu";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
          ignorePatterns = "// DO NOT IGNORE\n!/GC\n!/Wii\n!/GBA\n!/states\n!/StateSaves\n// IGNORE\n*\n.DS_Store";
        };
        "primehack-saves" = {
          path = "${homeDir}/.local/share/primehack";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
          ignorePatterns = "// DO NOT IGNORE\n!/GC\n!/Wii\n!/GBA\n!/states\n!/StateSaves\n// IGNORE\n*\n.DS_Store";
        };
        "ppsspp-saves" = {
          path = "${homeDir}/.var/app/org.ppsspp.PPSSPP/config/ppsspp/PSP";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
          ignorePatterns = "// DO NOT IGNORE\n!/PPSSPP_STATE\n!/SAVEDATA\n// IGNORE\n*\n.DS_Store";
        };
        "pcsx2-states" = {
          path = "${emuBase}/saves/pcsx2/states";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "pcsx2-saves" = {
          path = "${emuBase}/saves/pcsx2/saves";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "yuzu-nand" = {
          path = "${emuBase}/storage/yuzu/nand";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "eden-nand" = {
          path = "${emuBase}/storage/eden/nand";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
        "roms" = {
          path = "${emuBase}/roms/";
          devices = [ "proxmox-syncthing" ];
          type = "sendreceive";
        };
      };
    };
  };
}

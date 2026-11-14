{
  config.flake.factory.syncthingFactory = { baseDirectory }:
    let
      emuBase = "${baseDirectory}/Emulation";
    in
    {
      services.syncthing = {
        guiAddress = "127.0.0.1:8384";
        settings = {
          # gui.address = "127.0.0.1:8384";
          folders = {
            "kando" = {
              path = "${baseDirectory}/.config/kando";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
            };
            "mame-saves" = {
              path = "${baseDirectory}/.mame";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
              ignorePatterns = [ "// DO NOT IGNORE" "!/nvram" "!/sta" "// IGNORE" "*" ".DS_Store" ];
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
              path = "${baseDirectory}/.var/app/org.libretro.RetroArch/config/retroarch";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
              ignorePatterns = [ "// DO NOT IGNORE" "!/states" "!/saves" "// IGNORE" "*" ".DS_Store" ];
            };
            "ryujinx-saves" = {
              path = "${baseDirectory}/.config/Ryujinx/bis";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
            };
            "rpcs3-saves" = {
              path = "${emuBase}/saves/rpcs3/saves";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
            };
            "dolphin-saves" = {
              path = "${baseDirectory}/.local/share/dolphin-emu";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
              ignorePatterns = [ "// DO NOT IGNORE" "!/GC" "!/Wii" "!/GBA" "!/states" "!/StateSaves" "// IGNORE" "*" ".DS_Store" ];
            };
            "primehack-saves" = {
              path = "${baseDirectory}/.local/share/primehack";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
              ignorePatterns = [ "// DO NOT IGNORE" "!/GC" "!/Wii" "!/GBA" "!/states" "!/StateSaves" "// IGNORE" "*" ".DS_Store" ];
            };
            "ppsspp-saves" = {
              path = "${baseDirectory}/.var/app/org.ppsspp.PPSSPP/config/ppsspp/PSP";
              devices = [ "proxmox-syncthing" ];
              type = "sendreceive";
              ignorePatterns = [ "// DO NOT IGNORE" "!/PPSSPP_STATE" "!/SAVEDATA" "// IGNORE" "*" ".DS_Store" ];
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
    };
}

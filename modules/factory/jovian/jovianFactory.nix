{ inputs, ... }:
{
  config.flake.factory.jovian = user: desktopSession: { pkgs, config, options, lib, ... }:
    let
      deckyNexus = pkgs.fetchzip rec {
        version = "1.21.40";
        url = "https://github.com/RedRanger14/decky-nexus/releases/download/v${version}/Nexus-Mods-${version}.zip";
        hash = "sha256-AnVIqEpaNnGslrKqCChlrT3DKAQNh6T4VfWBR9m+AfA=";
        stripRoot = false;
      };
      pluginDir = "${config.jovian.decky-loader.stateDir}/plugins";
      electronLibraries = with pkgs; [
        alsa-lib
        at-spi2-core
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        glib
        gtk3
        libdrm
        libgbm
        libglvnd
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxkbcommon
        libxrandr
        libxrender
        libxshmfence
        libxtst
        nspr
        nss
        pango
      ];
    in
    {
      imports = [ inputs.jovian.nixosModules.default ];
      jovian = {
        # devices.steamdeck.enable = true;
        devices.steamdeck.autoUpdate = true;
        decky-loader = {
          enable = true;
          inherit user;
          stateDir = "/home/${user}/homebrew";
          extraPackages = with pkgs; [
            yt-dlp
            unrar
            p7zip
            libarchive
            ryzenadj
            unzip
          ];
          extraPythonPackages = p: [
            p.requests
            p.pillow
          ];
        };
        steam = {
          enable = true;
          autoStart = true;
          inherit user;
          inherit desktopSession;
          # desktopSession = "umbriel";
        };
      };
      programs.nix-ld = {
        enable = true;
        libraries = options.programs.nix-ld.libraries.default ++ electronLibraries;
      };
      system.activationScripts.decky-nexus = lib.stringAfter [ "var" ] ''
        mkdir -p "${pluginDir}"
        rm -rf "${pluginDir}/Nexus Mods"
        cp -r --no-preserve=mode,ownership "${deckyNexus}/." "${pluginDir}/"
      '';
      programs.steam.extraPackages = electronLibraries;
    };
}

{ pkgs, ... }:
let
  amethyst = pkgs.appimageTools.wrapType2 rec {
    pname = "amethyst-mod-manager";
    version = "1.0.8";

    src = pkgs.fetchurl {
      url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager-${version}-x86_64.AppImage";
      sha256 = "sha256:bfa545bafa0ed5aad84fd00c8fda92780044196f7606f6fdb6c8014e2a7ecdbc";
    };

    extraPkgs =
      p: with p; [
        xdg-utils
        libXft
      ];
  };
in
{
  home = {
    shellAliases = {
      am = "amethyst-mod-manager";
    };
    packages = [ amethyst ];
  };

  xdg = {
    enable = true;
    desktopEntries.amethyst-mod-manager = {
      name = "Amethyst Mod Manager";
      comment = "Native Linux mod manager for Bethesda games";
      exec = "amethyst-mod-manager %f";
      categories = [
        "Game"
        "Utility"
      ];
      terminal = false;
      mimeType = [ "x-scheme-handler/nxm" ];
    };
  };
}

{ pkgs, ... }:
let
  cac-google-setup = pkgs.writeShellScriptBin "cac-google-setup" ''
    #!/bin/sh
    NSSDB="''${HOME}/.pki/nssdb"
    mkdir -p ''${NSSDB}
    ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add cac-card \
      -libfile ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';
in
{
  xdg.configFile = {
    "autostart/kando.desktop".text = ''
      [Desktop Entry]
      Name=Kando
      Exec=${pkgs.kando}/bin/kando
      Icon=kando
      StartupNotify=true
      Terminal=false
      Type=Application
      Keywords=kando;mouse;
      Categories=Utility;GTK;
    '';
    "autostart/solaar.desktop".text = ''
      [Desktop Entry]
      Name=Solaar
      Exec=${pkgs.solaar}/bin/solaar --window=hide
      Icon=solaar
      StartupNotify=true
      Terminal=false
      Type=Application
      Keywords=logitech;unifying;receiver;mouse;keyboard;
      Categories=Utility;GTK;
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    (pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [ plex-for-kodi ]))
    flips
    freecad
    google-chrome
    kando
    kdePackages.ark
    kdePackages.dolphin
    kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-gdrive
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.kservice
    kdePackages.qt6ct
    kdePackages.skanlite
    libreoffice
    nixd
    solaar
    system-config-printer
    virt-viewer
    cac-google-setup
  ];
  home.file.".local/share/kservices6/ServiceMenus/steam.desktop".source =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/vicrodh/steamos-add-to-steam/main/share/kservices/steam.desktop";
      sha256 = "1xlx3j4468g2dnv15appr2qj0aaw9hky32binklr2sjzs8v0cnr0";
    };

  xdg.mimeApps = {
    associations.added."applications/zip" = [ "org.kde.ark.desktop" ];
    defaultApplications."applications/zip" = [ "org.kde.ark.desktop" ];
    associations.added."applications/x-compress-tar" = [ "org.kde.ark.desktop" ];
    defaultApplications."applications/x-compress-tar" = [ "org.kde.ark.desktop" ];
  };
}

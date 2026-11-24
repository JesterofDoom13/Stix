{
  flake.modules.nixos.pcmanfm = { pkgs, ... }: {
    environment.systemPackages = with pkgs;[
      pcmanfm-qt
    ];
  };
  flake.modules.homeManager.pcmanfm = { pkgs, config, ... }: {
    home.packages = with pkgs;[
      marwaita-icons
      pcmanfm-qt
      qt6Packages.qt6ct
    ];
    home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
    systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

    # NixOS gotcha: a wrapped Qt app only sees its own plugins, so it may not
    # find the qt6ct platform theme plugin. Point Qt at it explicitly.
    home.sessionVariables.QT_PLUGIN_PATH =
      "${pkgs.qt6Packages.qt6ct}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    # Only qt6ct.conf is Nix-managed (read-only). Noctalia writes
    # ~/.config/qt6ct/colors/noctalia.conf, a separate real file, so no collision.
    xdg.configFile."qt6ct/qt6ct.conf".text = ''
      [Appearance]
      custom_palette=true
      color_scheme_path=${config.xdg.configHome}/qt6ct/colors/noctalia.conf
      style=Fusion
      standard_dialogs=default
      icon_theme=Marwaita-Dark
    '';
  };
}

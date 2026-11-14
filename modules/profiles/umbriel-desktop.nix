{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.nixos.umbriel-desktop.imports = with m.nixos; [
    umbriel

    bluetooth
    flatpak
    minimal
    openlogi
    pcmanfm
  ];
  flake.modules.homeManager.umbriel-desktop.imports = with m.homeManager; [
    umbriel

    browsers
    gaming
    ghostty
    minimal
    noctalia
    orca
    pcmanfm
    zathura
  ];
}


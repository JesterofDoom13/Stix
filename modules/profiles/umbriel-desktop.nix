{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.nixos.umbriel-desktop.imports = with m.nixos; [
    umbriel

    # List of Modules that pull in multiple defaults
    minimal
    filemanager

    bluetooth
    sunshine
    flatpak # DO NOT REMOVE. Designed to pull in if homeManager has enabled a flatpak.
  ];
  flake.modules.homeManager.umbriel-desktop.imports = with m.homeManager; [
    umbriel

    # List of modules that pull in multiple defaults
    minimal
    filemanager
    browsers
    gaming

    # Individual programs
    sunshine
    ghostty
    noctalia
    orca
    zathura
  ];
}


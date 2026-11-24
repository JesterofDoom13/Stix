{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.nixos.filemanager.imports = with m.nixos; [
    # nordend
    luciole
  ];
  flake.modules.homeManager.filemanager.imports = with m.homeManager; [
    # nordend
    luciole
  ];
}


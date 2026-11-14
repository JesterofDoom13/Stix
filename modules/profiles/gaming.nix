{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.nixos.gaming.imports = with m.nixos; [
    flatpak
  ];
  flake.modules.homeManager.gaming.imports = with m.homeManager; [
    lichii
    eden
    retrodeck
    srm
    xbox-cloud-gaming
  ];
}

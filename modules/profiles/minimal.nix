{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.nixos.minimal.imports = with m.nixos; [
    cli-tools
    ssh
  ];
  flake.modules.homeManager.minimal.imports = with m.homeManager; [
    shell
    tmux
    neovim
    yazi
  ];
}

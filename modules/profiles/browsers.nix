{ inputs, ... }:
let m = inputs.self.modules; in
{
  flake.modules.homeManager.browsers.imports = with m.homeManager; [
    chrome
    qutebrowser
    zen
  ];
}

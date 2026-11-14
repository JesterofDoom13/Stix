{ inputs, ... }:
{
  flake.modules.homeManager.retrodeck = {
    imports = [ inputs.self.modules.homeManager.flatpak ];
    services.flatpak.packages = [

      "net.retrodeck.retrodeck"
      "com.github.tchx84.Flatseal"
    ];
  };
}


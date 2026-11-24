{ inputs, ... }:
{
  flake.modules.homeManager.orca = { pkgs, config, ... }:
    let
      mkFolder = inputs.self.lib.syncthing.mkFolder config;
    in
    {
      imports = [ inputs.self.modules.homeManager.syncthing ];
      home.packages = [ pkgs.orca-slicer ];

      services.syncthing.settings.folders."orca-slicer" = mkFolder "${config.home.homeDirectory}/.config/OrcaSlicer" { };
    };
}

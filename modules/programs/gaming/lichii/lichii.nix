{ inputs, ... }:
{
  flake.modules.homeManager.lichii = { pkgs, lib, config, ... }:
    let
      mkFolder = inputs.self.lib.syncthing.mkFolder config;
    in
    {
      home.packages = [
        (lib.lowPrio (pkgs.callPackage (inputs.self + "/pkgs/lichii.nix") {
          src = inputs.lichii;
        }))
      ];

      services.syncthing.settings.folders."lichii-nand" = mkFolder "${config.xdg.dataHome}/lichii/nand" { };
    };
}

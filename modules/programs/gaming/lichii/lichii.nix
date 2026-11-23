{ inputs, ... }:
{
  flake.modules.homeManager.lichii = { pkgs, lib, config, ... }:
    let
      # Part of the commented out part below
      mkFolder = inputs.self.lib.syncthing.mkFolder config;
    in
    {
      home.packages = [
        (lib.lowPrio (pkgs.callPackage (inputs.self + "/pkgs/lichii.nix") {
          src = inputs.lichii;
        }))
      ];

      # Have to add these invidually to each user finding out what the last directory 32 character is when lichii starts
      services.syncthing.settings.folders."lichii-nand" = mkFolder "${config.xdg.dataHome}/lichii/nand/user/save" { };
    };
}

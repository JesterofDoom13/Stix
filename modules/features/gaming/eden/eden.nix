{ inputs, ... }:
{
  flake.modules.homeManager.eden = { pkgs, config, ... }:
    let
      mkFolder = inputs.self.lib.syncthing.mkFolder config;
    in
    {
      home.packages = with pkgs; [
        eden
      ];
      services.syncthing.settings.folders."eden-nand" = mkFolder "${config.xdg.dataHome}/eden/nand" { };
    };
}

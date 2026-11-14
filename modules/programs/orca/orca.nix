{ inputs, ... }:
{
  flake.modules.homeManager.orca = { pkgs, config, ... }: {
    imports = [ inputs.self.modules.homeManager.syncthing ];

    home.packages = [ pkgs.orca-slicer ];

    services.syncthing.settings.folders."orca-slicer" = {
      path = "${config.home.homeDirectory}/.config/OrcaSlicer";
      devices = [ "proxmox-syncthing" ];
      type = "sendreceive";
    };
  };
}

{ lib, ... }:
{
  flake.lib.syncthing.mkFolder = hmConfig: path: extra: {
    inherit path;
    devices = lib.mkDefault (lib.attrNames (hmConfig.services.syncthing.settings.devices or { }));
    type = "sendreceive";
  } // extra;
}

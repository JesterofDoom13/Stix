{ lib, ... }:
{
  options.flake.meta = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.str;
    default = { };
    description = "Shared constants used across modules.";
  };

  config.flake.meta.gpgKeyId = "D29E85FF9B3B52B7";
}

{ inputs, ... }:
{
  flake.modules.homeManager.lichii = { pkgs, lib, ... }: {
    home.packages = [
      (lib.lowPrio (pkgs.callPackage (inputs.self + "/pkgs/lichii.nix") {
        src = inputs.lichii;
      }))
    ];
  };
}

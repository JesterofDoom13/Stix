{ ... }:
{
  flake.modules.nixos.prox-nvidia = { config, lib, pkgs, ... }:
    let
      nvidiaLibs =
        (config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "595.84";
          sha256_64bit = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
          sha256_aarch64 = lib.fakeHash;
          openSha256 = lib.fakeHash;
          settingsSha256 = lib.fakeHash;
          persistencedSha256 = lib.fakeHash;
        }).override { libsOnly = true; };
    in
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # Steam / 32-bit games
        extraPackages = [ nvidiaLibs pkgs.egl-gbm pkgs.egl-wayland ];
        extraPackages32 = [ nvidiaLibs.lib32 ];

      };

      environment.etc."egl/egl_external_platform.d".source =
        "/run/opengl-driver/share/egl/egl_external_platform.d/";

      environment.sessionVariables.WLR_DRM_DEVICES = "/dev/dri/card2";
    };
}

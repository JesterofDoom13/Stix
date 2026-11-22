{ ... }:
{
  flake.modules.nixos.prox-nvidia = { config, lib, ... }:
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
        extraPackages = [ nvidiaLibs ];
        extraPackages32 = [ nvidiaLibs.lib32 ];

      };

      # services.xserver.videoDrivers = [ "nvidia" ];

      # hardware.nvidia = {
      #   modesetting.enable = true;
      #   open = false;
      #   nvidiaSettings = false;
      #   gsp.enable = false;
      #   # Userspace libs only: the kernel module comes from the Proxmox host.
      #   # Version must match the host exactly.
      #   package =
      #     (config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #       version = "595.84";
      #       sha256_64bit = lib.fakeHash;
      #       sha256_aarch64 = lib.fakeHash;
      #       openSha256 = lib.fakeHash;
      #       settingsSha256 = lib.fakeHash;
      #       persistencedSha256 = lib.fakeHash;
      #     }).override {
      #       libsOnly = true;
      #       # kernel = null;
      #     };
      # };
    };
}

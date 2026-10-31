{ pkgs, ... }:
let
  sink = "alsa_output.pci-0000_04_00.1.hdmi-surround71-extra2";

  jellyfin-hdr = pkgs.writeShellApplication {
    name = "jellyfin-hdr";
    runtimeInputs = [ pkgs.jellyfin-desktop ];
    text = ''
      export ENABLE_GAMESCOPE_WSI=1
      exec jellyfin-desktop "$@"
    '';
  };
in
{
  home.packages = [ jellyfin-hdr ];

  xdg.dataFile."jellyfin-desktop/mpv.conf".text = ''
    vo=gpu-next
    gpu-api=vulkan
    gpu-context=waylandvk
    hwdec=vaapi
    target-colorspace-hint=yes

    ao=pipewire
    audio-device=pipewire/${sink}
    audio-channels=7.1
  '';
}

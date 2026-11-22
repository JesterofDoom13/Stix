{
  flake.modules.nixos.sunshine = { ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = false; # only needed for KMS capture, not capture = wlr
      openFirewall = true;
    };
    hardware.uinput.enable = true;
    # For dualshock controller support (no effect inside an LXC; set mode= on the Proxmox dev lines)
    services.udev.extraRules = ''
      KERNEL=="uhid", GROUP="input", MODE="0660", OPTIONS+="static_node=uhid", TAG+="uaccess"
    '';
  };

  flake.modules.homeManager.sunshine = { config, pkgs, ... }: {
    programs.umbriel.settings.window_rule = [{
      match = {
        app_id = "^steam$";
        title = "[Bb]ig [Pp]icture";
      };
      default_output = "sunshine";
      default_fullscreen = true;
    }];
    xdg.configFile = {
      "sunshine/sunshine.conf".text = ''
        capture = wlr
        output_name = sunshine
        csrf_allowed_origins = https://10.0.0.233:47990,https://gamix:47990,https://100.64.0.17:47990
        global_prep_cmd = [{"do":"${config.xdg.configHome}/sunshine/umbriel-output.sh create","undo":"${config.xdg.configHome}/sunshine/umbriel-output.sh remove"}]
      '';
      "sunshine/umbriel-output.sh" = {
        executable = true;
        text = ''
          #!/bin/sh
          set -eu
          export PATH="/run/current-system/sw/bin:$PATH"
          jq=${pkgs.jq}/bin/jq

          name=sunshine

          case "$1" in
              create)
                  umbriel output-destroy "$name" >/dev/null 2>&1 || true
                  umbriel output-create "$name" \
                      "''${SUNSHINE_CLIENT_WIDTH:-1920}x''${SUNSHINE_CLIENT_HEIGHT:-1080}@''${SUNSHINE_CLIENT_FPS:-60}" >/dev/null
                  ;;
              remove)
                  i=0
                  while [ "$i" -lt 25 ]; do
                      left="$(umbriel windows --json |
                          $jq --arg out "$name:" '[.[] | select(.workspace | startswith($out))] | length')"
                      [ "$left" = 0 ] && break
                      sleep 0.2
                      i=$((i + 1))
                  done
                  target="$(umbriel workspaces --json |
                      $jq -r --arg out "$name" '[.[] | select(.output != $out and .active)]
                          | (map(select(.focused)) + .) | first | "\(.name)/\(.output)" // empty')"
                  for id in $(umbriel windows --json |
                      $jq -r --arg out "$name:" '.[] | select(.workspace | startswith($out)) | .id'); do
                      [ -n "$target" ] || break
                      umbriel msg window-focus "$id"
                      umbriel msg window-move-to-workspace-silent "$target"
                  done
                  umbriel output-destroy "$name" >/dev/null 2>&1 || true
                  ;;
          esac
        '';
      };
    };
  };
}

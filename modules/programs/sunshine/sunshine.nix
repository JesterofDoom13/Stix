{
  flake.modules.nixos.pcmanfm = { pkgs, ... }: {
    environment.systemPackages = with pkgs;[
      sunshine
    ];
  };
  flake.modules.homeManager.pcmanfm = { pkgs, ... }: {
    home = {
      packages = with pkgs;[
        sunshine
      ];
    };
    programs.umbriel.settings.window_rule = {
      match.app_id = "^steam$";
      match.title = "[Bb]ig [Pp]icture";
      default_output = "sunshine";
      default_fullscreen = true;
    };
    xdg.configFile = {
      "sunshine/sunshine.conf".text = ''
        capture = wlr
        output_name = sunshine
        global_prep_cmd = [{"do":"/home/user/.config/sunshine/umbriel-output.sh create","undo":"/home/user/.config/sunshine/umbriel-output.sh remove"}]
      '';
      "sunshine/umbriel-output.sh" = {
        executable = true;
        text = ''
          #!/bin/sh
          set -eu

          name=sunshine

          case "$1" in
              create)
                  umbriel output-destroy "$name" >/dev/null 2>&1 || true
                  umbriel output-create "$name" \
                      "${SUNSHINE_CLIENT_WIDTH:-1920}x${SUNSHINE_CLIENT_HEIGHT:-1080}@${SUNSHINE_CLIENT_FPS:-60}" >/dev/null
                  ;;
              remove)
                  # Give windows that the app's undo command is closing up to 5 seconds to
                  # go away, so they do not flash onto a physical monitor.
                  i=0
                  while [ "$i" -lt 25 ]; do
                      left="$(umbriel windows --json |
                          jq --arg out "$name:" '[.[] | select(.workspace | startswith($out))] | length')"
                      [ "$left" = 0 ] && break
                      sleep 0.2
                      i=$((i + 1))
                  done
                  # Move what is left to the focused workspace of another output, so it
                  # does not return to the next session's output (see below).
                  target="$(umbriel workspaces --json |
                      jq -r --arg out "$name" '[.[] | select(.output != $out and .active)]
                          | (map(select(.focused)) + .) | first | "\(.name)/\(.output)" // empty')"
                  for id in $(umbriel windows --json |
                      jq -r --arg out "$name:" '.[] | select(.workspace | startswith($out)) | .id'); do
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
















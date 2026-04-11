{ pkgs, inputs, ... }:
let
  src = inputs.niri-tweaks;

  niri-tile-to-n = pkgs.writers.writePython3Bin "niri-tile-to-n"
    {
      libraries = [ ];
      doCheck = false;
    }
    (builtins.readFile "${src}/niri_tile_to_n.py");

  niri-spawnjump = pkgs.writers.writePython3Bin "niri-spawnjump"
    {
      libraries = [ ];
      doCheck = false;
    }
    (builtins.readFile "${src}/niri_spawnjump.py");

  niri-workspace-helper = pkgs.writers.writePython3Bin "niri-workspace-helper"
    {
      libraries = [ ];
      doCheck = false;
    }
    (builtins.readFile "${src}/niri_workspace_helper.py");

  niri-peekaboo = pkgs.writers.writePython3Bin "niri-peekaboo"
    {
      libraries = [ ];
      doCheck = false;
    }
    (builtins.readFile "${src}/niri_peekaboo.py");

  niri-parse-keybinds = pkgs.writers.writePython3Bin "niri-parse-keybinds"
    {
      libraries = [ ];
      doCheck = false;
    }
    (builtins.readFile "${src}/niri_parse_keybinds.py");

  niri-window-details = pkgs.writeShellScriptBin "niri-window-details"
    (builtins.readFile "${src}/niri_window_details.sh");

  niri-overview-bind = pkgs.writeShellScriptBin "niri-overview-bind"
    (builtins.readFile "${src}/niri_overview_bind.sh");

  fuzzel-helper = pkgs.writeShellScriptBin "fuzzel-helper"
    (builtins.readFile "${src}/fuzzel_helper.sh");

in
{
  home.packages = [
    niri-tile-to-n
    niri-spawnjump
    niri-workspace-helper
    niri-peekaboo
    niri-parse-keybinds
    niri-window-details
    niri-overview-bind
    fuzzel-helper
  ];
}

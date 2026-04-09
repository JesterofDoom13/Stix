{ pkgs, inputs, ... }:
let
  src = inputs.niri-tweaks;

  # Package each script
  niri-tile-to-n = pkgs.writers.writePython3Bin "niri-tile-to-n"
    {
      libraries = [ ];
      doCheck = false; # This disables the flake8/pycodestyle linting checkj
    }
    (builtins.readFile "${src}/niri_tile_to_n.py");

  niri-spawnjump = pkgs.writers.writePython3Bin "niri-spawnjump"
    {
      libraries = [ ];
      doCheck = false; # This disables the flake8/pycodestyle linting checkj
    }
    (builtins.readFile "${src}/niri_spawnjump.py");

  niri-workspace-helper = pkgs.writers.writePython3Bin "niri-workspace-helper"
    {
      libraries = [ ];
      doCheck = false; # This disables the flake8/pycodestyle linting checkj
    }
    (builtins.readFile "${src}/niri_workspace_helper.py");

  niri-peekaboo = pkgs.writers.writePython3Bin "niri-peekaboo"
    {
      libraries = [ ];
      doCheck = false; # This disables the flake8/pycodestyle linting checkj
    }
    (builtins.readFile "${src}/niri_peekaboo.py");

  niri-parse-keybinds = pkgs.writers.writePython3Bin "niri-parse-keybinds"
    {
      libraries = [ ];
      doCheck = false; # This disables the flake8/pycodestyle linting checkj
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

  # Auto-start tile-to-n on niri startup
  # programs.niri.settings.spawn-at-startup = [
  #   { command = [ "${niri-tile-to-n}/bin/niri-tile-to-n" ]; }
  # ];
}

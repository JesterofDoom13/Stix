{ pkgs, ... }:
{
  imports = [
    # ./dolphin.nix
    # ./srm.nix
    ./xbox-cloud-gaming.nix
  ];
  home.packages = with pkgs; [
    eden
    discord
    discover-overlay
    (writeShellScriptBin "with-discord-overlay" ''
      #!/usr/bin/env bash
      unset LD_PRELOAD
      discover-overlay --steamos &
      overlay_pid=$!

      "$@"
      game_status=$?

      kill "$overlay_pid" 2>/dev/null

      exit $game_status
    '')
  ];

  programs.xbox-cloud-gaming.enable = true;
}

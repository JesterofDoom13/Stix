{ inputs
, pkgs
, config
, lib
, ...
}:
let
  # Update noctalia before every build. sn = sync noctalia
  sn = pkgs.writeShellScriptBin "sn" ''
    #!/bin/bash
    set - e
    CONFIG_DIR="${config.programs.nh.flake}"
    OUTPUT="$CONFIG_DIR/assets/noctalia-settings.toml"

    echo "Syncing noctalia settings..."
    noctalia config export > "$OUTPUT"
    noctalia config validate "$OUTPUT"
    echo "Saved to $OUTPUT"
  '';
  # Now use those settings
  settingsFile = ../../assets/noctalia-settings.toml;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
  };
  home = {

    packages = with pkgs; [
      sn
      jq
    ];
    file = {
      # Main config
      ".config/noctalia/zz-synced.toml" = lib.mkIf (builtins.pathExists settingsFile) {
        source = settingsFile;
      };
      # -- Personal templates for noctalia to handle. -----
      ".config/noctalia/templates.toml".text = ''
        [theme.templates.user.tmux]
        input_path  = "$XDG_CONFIG_HOME/noctalia/templates/tmux.conf"
        output_path = "$XDG_CONFIG_HOME/tmux/noctalia.conf"
        post_hook   = "tmux source-file $XDG_CONFIG_HOME/tmux/noctalia.conf 2>/dev/null || true"
        [theme.templates.user.fish]
        input_path  = "$XDG_CONFIG_HOME/noctalia/templates/colors-template.fish"
        output_path = "$XDG_CONFIG_HOME/fish/generated-colors.fish"
        post_hook   = "fish $XDG_CONFIG_HOME/fish/generated-colors.fish"
      '';
      # -- Tmux template  ------------------------------------
      ".config/noctalia/templates/tmux.conf".text = ''
        # Status bar background and foreground
        set -g status-style "bg={{colors.surface.default.hex}},fg={{colors.on_surface.default.hex}}"
        # Window selection colors
        set -g window-status-current-style "bg={{colors.primary.default.hex}},fg={{colors.on_primary.default.hex}},bold"
        set -g window-status-style "fg={{colors.surface.default.hex}},bg={{colors.on_surface_variant.default.hex}}"
        # Pane borders
        set -g pane-border-style "fg={{colors.outline.default.hex}}"
        set -g pane-active-border-style "fg={{colors.primary.default.hex}}"
        # Message command line
        set -g message-style "bg={{colors.secondary_container.default.hex}},fg={{colors.on_secondary_container.default.hex}}"
      '';
      # TODO: Haven't gotten this working yet
      # -- fish noctalia wallpaper template ------------------
      ".config/noctalia/templates/colors-template.fish".text = ''
        set -U fish_color_normal {{colors.on_surface.default.hex_stripped}}
        set -U fish_color_command {{colors.primary.default.hex_stripped}} --bold
        set -U fish_color_keyword {{colors.tertiary.default.hex_stripped}}
        set -U fish_color_quote {{colors.secondary.default.hex_stripped}}
        set -U fish_color_redirection {{colors.primary_container.default.hex_stripped}}
        set -U fish_color_end {{colors.on_surface_variant.default.hex_stripped}}
        set -U fish_color_error {{colors.error.default.hex_stripped}}
        set -U fish_color_param {{colors.on_surface.default.hex_stripped}}
        set -U fish_color_comment {{colors.outline.default.hex_stripped}}
        set -U fish_color_selection --background={{colors.surface_container_high.default.hex_stripped}}
        set -U fish_color_search_match --background={{colors.surface_container_highest.default.hex_stripped}}
        set -U fish_color_operator {{colors.primary.default.hex_stripped}}
        set -U fish_color_escape {{colors.secondary.default.hex_stripped}}
        set -U fish_color_autosuggestion {{colors.outline.default.hex_stripped}}
        set -U fish_pager_color_progress {{colors.on_surface_variant.default.hex_stripped}}
        set -U fish_pager_color_prefix {{colors.primary.default.hex_stripped}} --bold --underline
        set -U fish_pager_color_completion {{colors.on_surface.default.hex_stripped}}
        set -U fish_pager_color_description {{colors.outline.default.hex_stripped}}
      '';
      ".local/state/noctalia/community-templates/neovim/template.toml" = {
        text = ''
          [catalog.neovim]
          name = "Neovim"
          category = "editor"

          [templates.nvim-base16]
          input_path = "$XDG_CONFIG_HOME/nvim/lua/templates/matugen-template.lua"
          output_path = "$XDG_CONFIG_HOME/nvim/lua/matugen.lua"
          post_hook = "bash '{{ config_dir }}/apply.sh'"
        '';
      };
    };
  };

  # Launch noctalia on niri startup
  programs.niri.settings.spawn-at-startup = [
    { command = [ "noctalia" ]; }
  ];
}

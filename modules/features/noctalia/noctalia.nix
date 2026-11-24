{ inputs, ... }: {

  flake.modules.homeManager.noctalia = { pkgs, lib, ... }:
    let
      reloadScript = pkgs.writeShellApplication {
        name = "qutebrowser-noctalia-reload";
        # Add any CLI tools the script uses (e.g., pkgs.jq, pkgs.procps)
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          echo "Reloading Noctalia theme for qutebrowser..."
          # Your reload commands here
        '';
      };
      # Update noctalia before every build. sn = sync noctalia
      sn = pkgs.writeShellScriptBin "sn" ''
        #!/bin/bash
        set -e
        CONFIG_DIR="$HOME/Stix"
        OUTPUT="$CONFIG_DIR/assets/noctalia-settings.toml"

        echo "Syncing noctalia settings..."
        noctalia config export > "$OUTPUT"
        noctalia config validate "$OUTPUT"
        echo "Saved to $OUTPUT"
      '';
      # Now use those settings
      settingsFile = (inputs.self + "/assets/noctalia-settings.toml");
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
      };
      # -- For Qutebrowser theming


      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
      };
      home = {
        packages = with pkgs;
          [
            sn
            adw-gtk3
            # Glib for use with phone connect plugin in noctalia
            # really just needs it for the gdbus.
            glib

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
            output_path = "$XDG_CONFIG_HOME/tmux/noctalia-colors.conf"
            post_hook   = "tmux source-file $XDG_CONFIG_HOME/tmux/noctalia.conf 2>/dev/null || true"
            [theme.templates.user.fish]
            input_path  = "$XDG_CONFIG_HOME/noctalia/templates/colors-template.fish"
            output_path = "$XDG_CONFIG_HOME/fish/generated-colors.fish"
            post_hook   = "fish $XDG_CONFIG_HOME/fish/generated-colors.fish"
            [theme.templates.user.qutebrowser]
            input_path  = "$XDG_CONFIG_HOME/qutebrowser/noctalia/template.py"
            output_path = "$XDG_CONFIG_HOME/qutebrowser/noctalia/colors.py"
            post_hook   = "sh $XDG_CONFIG_HOME/qutebrowser/noctalia/reload.sh" 
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
          # -- fish noctalia wallpaper template ------------------
          ".config/noctalia/templates/noctalia-colors.fish".text = ''
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
          # -- qutebrowser noctalia wallpaper community-templates ----------
          ".config/qutebrowser/noctalia/reload.sh" = {
            source = "${reloadScript}/bin/qutebrowser-noctalia-reload";
            executable = true;
          };
          ".config/qutebrowser/noctalia/template.py".text = ''
            # Noctalia qutebrowser theme - Material Design 3 Colors
            # Auto-generated from matugen color schemes
            # Theme adapts automatically based on your wallpaper and noctalia settings
            #
            # Color Mapping:
            # - Surface colors for backgrounds (surface, surface_container, surface_variant)
            # - Primary colors for accents and highlights
            # - Secondary colors for complementary elements
            # - Tertiary colors for additional accents
            # - Error colors for warnings and errors
            # - Outline colors for borders and separators

            # Base Surface Colors
            surface = "{{colors.surface.default.hex}}"
            surface_dim = "{{colors.surface_dim.default.hex}}"
            surface_bright = "{{colors.surface_bright.default.hex}}"
            surface_container = "{{colors.surface_container.default.hex}}"
            surface_container_low = "{{colors.surface_container_low.default.hex}}"
            surface_container_lowest = "{{colors.surface_container_lowest.default.hex}}"
            surface_container_high = "{{colors.surface_container_high.default.hex}}"
            surface_container_highest = "{{colors.surface_container_highest.default.hex}}"
            surface_variant = "{{colors.surface_variant.default.hex}}"

            # Foreground Colors
            on_surface = "{{colors.on_surface.default.hex}}"
            on_surface_variant = "{{colors.on_surface_variant.default.hex}}"

            # Primary Colors
            primary = "{{colors.primary.default.hex}}"
            on_primary = "{{colors.on_primary.default.hex}}"
            primary_container = "{{colors.primary_container.default.hex}}"
            on_primary_container = "{{colors.on_primary_container.default.hex}}"

            # Secondary Colors
            secondary = "{{colors.secondary.default.hex}}"
            on_secondary = "{{colors.on_secondary.default.hex}}"
            secondary_container = "{{colors.secondary_container.default.hex}}"
            on_secondary_container = "{{colors.on_secondary_container.default.hex}}"

            # Tertiary Colors
            tertiary = "{{colors.tertiary.default.hex}}"
            on_tertiary = "{{colors.on_tertiary.default.hex}}"
            tertiary_container = "{{colors.tertiary_container.default.hex}}"
            on_tertiary_container = "{{colors.on_tertiary_container.default.hex}}"

            # Error Colors
            error = "{{colors.error.default.hex}}"
            on_error = "{{colors.on_error.default.hex}}"
            error_container = "{{colors.error_container.default.hex}}"
            on_error_container = "{{colors.on_error_container.default.hex}}"

            # Outline Colors
            outline = "{{colors.outline.default.hex}}"
            outline_variant = "{{colors.outline_variant.default.hex}}"

            # Special Colors
            inverse_surface = "{{colors.inverse_surface.default.hex}}"
            inverse_on_surface = "{{colors.inverse_on_surface.default.hex}}"
            inverse_primary = "{{colors.inverse_primary.default.hex}}"

            # Utility function to convert a #rrggbb hex color to an rgba() string with transparency.
            def hex_to_rgba(hex_color, alpha):
                """Convert a #rrggbb hex string to a qutebrowser-compatible rgba() string."""
                hex_color = hex_color.lstrip('#')
                r = int(hex_color[0:2], 16)
                g = int(hex_color[2:4], 16)
                b = int(hex_color[4:6], 16)
                return 'rgba({}, {}, {}, {})'.format(r, g, b, alpha)

            ### Completion

            # Text color of the completion widget. May be a single color to use for
            # all columns or a list of three colors, one for each column.
            c.colors.completion.fg = [on_surface, primary, tertiary]
            # Background color of the completion widget for odd rows.
            c.colors.completion.odd.bg = surface_container
            # Background color of the completion widget for even rows.
            c.colors.completion.even.bg = surface_container_low
            # Foreground color of completion widget category headers.
            c.colors.completion.category.fg = primary
            # Background color of the completion widget category headers.
            c.colors.completion.category.bg = surface_container_high
            # Top border color of the completion widget category headers.
            c.colors.completion.category.border.top = outline_variant
            # Bottom border color of the completion widget category headers.
            c.colors.completion.category.border.bottom = outline_variant
            # Foreground color of the selected completion item.
            c.colors.completion.item.selected.fg = on_primary_container
            # Background color of the selected completion item.
            c.colors.completion.item.selected.bg = primary_container
            # Top border color of the selected completion item.
            c.colors.completion.item.selected.border.top = primary_container
            # Bottom border color of the selected completion item.
            c.colors.completion.item.selected.border.bottom = primary_container
            # Foreground color of the matched text in the selected completion item.
            c.colors.completion.item.selected.match.fg = tertiary
            # Foreground color of the matched text in the completion.
            c.colors.completion.match.fg = tertiary
            # Color of the scrollbar handle in the completion view.
            c.colors.completion.scrollbar.fg = primary
            # Color of the scrollbar in the completion view.
            c.colors.completion.scrollbar.bg = surface_variant

            ### Context menu

            # Background color of disabled items in the context menu.
            c.colors.contextmenu.disabled.bg = surface_variant
            # Foreground color of disabled items in the context menu.
            c.colors.contextmenu.disabled.fg = on_surface_variant
            # Background color of the context menu. If set to null, the Qt default is used.
            c.colors.contextmenu.menu.bg = surface_container
            # Foreground color of the context menu. If set to null, the Qt default is used.
            c.colors.contextmenu.menu.fg = on_surface
            # Background color of the context menu's selected item. If set to null, the Qt default is used.
            c.colors.contextmenu.selected.bg = secondary_container
            # Foreground color of the context menu's selected item. If set to null, the Qt default is used.
            c.colors.contextmenu.selected.fg = on_secondary_container

            ### Downloads

            # Background color for the download bar.
            c.colors.downloads.bar.bg = surface
            # Color gradient start for download text.
            c.colors.downloads.start.fg = on_primary
            # Color gradient start for download backgrounds.
            c.colors.downloads.start.bg = primary
            # Color gradient end for download text.
            c.colors.downloads.stop.fg = on_secondary
            # Color gradient stop for download backgrounds.
            c.colors.downloads.stop.bg = secondary
            # Foreground color for downloads with errors.
            c.colors.downloads.error.fg = error

            ### Hints

            # Font color for hints.
            c.colors.hints.fg = primary
            # Background color for hints.
            c.colors.hints.bg = hex_to_rgba(on_primary, 0.7)
            # Font color for the matched part of hints.
            c.colors.hints.match.fg = on_primary_container
            # Border around hint labels.
            c.hints.border = f'1px solid {primary}'
            # Corner rounding for hint labels.
            c.hints.radius = 1

            ### Keyhint widget

            # Text color for the keyhint widget.
            c.colors.keyhint.fg = on_surface_variant
            # Highlight color for keys to complete the current keychain.
            c.colors.keyhint.suffix.fg = primary
            # Background color of the keyhint widget.
            c.colors.keyhint.bg = surface_container

            ### Messages

            # Foreground color of an error message.
            c.colors.messages.error.fg = on_error
            # Background color of an error message.
            c.colors.messages.error.bg = error
            # Border color of an error message.
            c.colors.messages.error.border = error
            # Foreground color of a warning message.
            c.colors.messages.warning.fg = on_error_container
            # Background color of a warning message.
            c.colors.messages.warning.bg = error_container
            # Border color of a warning message.
            c.colors.messages.warning.border = error_container
            # Foreground color of an info message.
            c.colors.messages.info.fg = on_surface
            # Background color of an info message.
            c.colors.messages.info.bg = surface_container
            # Border color of an info message.
            c.colors.messages.info.border = outline

            ### Prompts

            # Foreground color for prompts.
            c.colors.prompts.fg = on_surface
            # Border used around UI elements in prompts.
            c.colors.prompts.border = f'1px solid {outline}'
            # Background color for prompts.
            c.colors.prompts.bg = surface_container_high
            # Background color for the selected item in filename prompts.
            c.colors.prompts.selected.bg = secondary_container

            ### Statusbar

            # Foreground color of the statusbar.
            c.colors.statusbar.normal.fg = on_surface
            # Background color of the statusbar.
            c.colors.statusbar.normal.bg = surface
            # Foreground color of the statusbar in insert mode.
            c.colors.statusbar.insert.fg = on_primary
            # Background color of the statusbar in insert mode.
            c.colors.statusbar.insert.bg = primary
            # Foreground color of the statusbar in passthrough mode.
            c.colors.statusbar.passthrough.fg = on_secondary
            # Background color of the statusbar in passthrough mode.
            c.colors.statusbar.passthrough.bg = secondary
            # Foreground color of the statusbar in private browsing mode.
            c.colors.statusbar.private.fg = tertiary
            # Background color of the statusbar in private browsing mode.
            c.colors.statusbar.private.bg = surface
            # Foreground color of the statusbar in command mode.
            c.colors.statusbar.command.fg = on_surface
            # Background color of the statusbar in command mode.
            c.colors.statusbar.command.bg = surface_container
            # Foreground color of the statusbar in private browsing + command mode.
            c.colors.statusbar.command.private.fg = tertiary
            # Background color of the statusbar in private browsing + command mode.
            c.colors.statusbar.command.private.bg = surface_container
            # Foreground color of the statusbar in caret mode.
            c.colors.statusbar.caret.fg = on_tertiary
            # Background color of the statusbar in caret mode.
            c.colors.statusbar.caret.bg = tertiary
            # Foreground color of the statusbar in caret mode with a selection.
            c.colors.statusbar.caret.selection.fg = on_tertiary_container
            # Background color of the statusbar in caret mode with a selection.
            c.colors.statusbar.caret.selection.bg = tertiary_container
            # Background color of the progress bar.
            c.colors.statusbar.progress.bg = primary
            # Default foreground color of the URL in the statusbar.
            c.colors.statusbar.url.fg = on_surface_variant
            # Foreground color of the URL in the statusbar on error.
            c.colors.statusbar.url.error.fg = error
            # Foreground color of the URL in the statusbar for hovered links.
            c.colors.statusbar.url.hover.fg = primary
            # Foreground color of the URL in the statusbar on successful load (http).
            c.colors.statusbar.url.success.http.fg = error
            # Foreground color of the URL in the statusbar on successful load (https).
            c.colors.statusbar.url.success.https.fg = secondary
            # Foreground color of the URL in the statusbar when there's a warning.
            c.colors.statusbar.url.warn.fg = tertiary

            ### ---Tabs ---

            # Background color of the tab bar.
            c.colors.tabs.bar.bg = hex_to_rgba(surface, 1.0)
            # Color gradient start for the tab indicator.
            c.colors.tabs.indicator.start = primary
            # Color gradient end for the tab indicator.
            c.colors.tabs.indicator.stop = secondary
            # Color for the tab indicator on errors.
            c.colors.tabs.indicator.error = error
            # Foreground color of unselected odd tabs.
            c.colors.tabs.odd.fg = hex_to_rgba(on_primary_container, 0.6)
            # Background color of unselected odd tabs.
            c.colors.tabs.odd.bg = hex_to_rgba(primary_container, 1.0)
            # Foreground color of unselected even tabs.
            c.colors.tabs.even.fg = hex_to_rgba(on_primary_container, 0.6)
            # Background color of unselected even tabs.
            c.colors.tabs.even.bg = hex_to_rgba(primary_container, 1.0)
            # Foreground color of selected odd tabs.
            c.colors.tabs.selected.odd.fg = primary
            # Background color of selected odd tabs.
            c.colors.tabs.selected.odd.bg = hex_to_rgba(primary_container, 0.4)
            # Foreground color of selected even tabs.
            c.colors.tabs.selected.even.fg = primary
            # Background color of selected even tabs.
            c.colors.tabs.selected.even.bg = hex_to_rgba(primary_container, 0.4)
            # Foreground color of pinned unselected odd tabs.
            c.colors.tabs.pinned.odd.fg = hex_to_rgba(on_tertiary_container, 0.6)
            # Background color of pinned unselected odd tabs.
            c.colors.tabs.pinned.odd.bg = hex_to_rgba(tertiary_container, 1.0)
            # Foreground color of pinned unselected even tabs.
            c.colors.tabs.pinned.even.fg = hex_to_rgba(on_tertiary_container, 0.6)
            # Background color of pinned unselected even tabs.
            c.colors.tabs.pinned.even.bg = hex_to_rgba(tertiary_container, 1.0)
            # Foreground color of pinned selected odd tabs.
            c.colors.tabs.pinned.selected.odd.fg = tertiary
            # Background color of pinned selected odd tabs.
            c.colors.tabs.pinned.selected.odd.bg = hex_to_rgba(tertiary_container, 0.4)
            # Foreground color of pinned selected even tabs.
            c.colors.tabs.pinned.selected.even.fg = tertiary
            # Background color of pinned selected even tabs.
            c.colors.tabs.pinned.selected.even.bg = hex_to_rgba(tertiary_container, 0.4)

            # Background color for webpages if unset (or empty to use the theme's color).
            c.colors.webpage.bg = surface
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

    };
}

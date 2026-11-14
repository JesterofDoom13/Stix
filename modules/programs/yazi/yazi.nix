{ inputs, ... }: {

  flake.modules.homeManager.yazi = { pkgs, osConfig ? null, ... }:
    let
      # Resolve system from NixOS host config if available, falling back to x86_64-linux
      system = if osConfig != null then osConfig.nixpkgs.hostPlatform.system else "x86_64-linux";
      iso-mount-yazi = pkgs.writeTextDir "main.lua" ''
        local state = ya.sync(function()
          local h = cx.active.current.hovered
          return {
            cwd = tostring(cx.active.current.cwd),
            path = h and tostring(h.url) or nil,
            is_dir = h and h.cha.is_dir or false,
            selected = #cx.active.selected,
          }
        end)

        local function notify_err(title, msg)
          ya.notify { title = title, content = msg, timeout = 6, level = "error" }
        end

        local function leave(s)
          local out = Command("iso-source")
            :arg(s.cwd)
            :stdout(Command.PIPED)
            :stderr(Command.PIPED)
            :output()

          -- not an ISO mount root: normal behavior
          if not out or not out.status.success then
            return ya.emit("leave", {})
          end

          local iso = out.stdout:gsub("%s+$", "")

          local choice = ya.which {
            cands = {
              { on = "o", desc = "Original folder (where the ISO lives)" },
              { on = "p", desc = "Parent of the mount point" },
            },
            silent = false,
          }

          if choice == 1 then
            ya.emit("reveal", { iso })
          elseif choice == 2 then
            ya.emit("leave", {})
          end
          -- Esc / any other key: stay where you are
        end
    
        local function enter(s)
          -- nothing hovered, or files selected: default behavior
          if not s.path or s.selected > 0 then
            return ya.emit("open", {})
          end
          if s.is_dir then
            return ya.emit("enter", {})
          end
          if not s.path:lower():match("%.iso$") then
            return ya.emit("open", { hovered = true })
          end

          local out, err = Command("iso-mount")
            :arg(s.path)
            :stdout(Command.PIPED)
            :stderr(Command.PIPED)
            :output()

          if out and out.status.success then
            ya.emit("cd", { (out.stdout:gsub("%s+$", "")) })
          else
            notify_err("ISO mount failed", out and out.stderr or tostring(err))
          end
        end

        return {
          entry = function(_, job)
            local s = state()
            if job.args[1] == "leave" then
              leave(s)
            else
              enter(s)
            end
          end,
        }
      '';
    in
    {
      imports = [
        inputs.nix-yazi-plugins.legacyPackages.${system}.homeManagerModules.default
      ];

      home.packages = with pkgs; [
        fuse-archive
        xxhash
        fuse3
      ];

      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        shellWrapperName = "y";
        initLua = ''
          require("fuse-archive"):setup({
            smart_enter = true, -- Opens files directly, enters directories
          })
        '';
        keymap = {
          mgr.prepend_keymap = [
            { on = [ "M" ]; run = "plugin mount"; desc = "Toggle Mount for iso"; }
            { on = [ "c" "M" ]; run = [ ''shell 'udisksctl loop-setup -r -f "$1"' --block --confirm'' "plugin mount" ]; desc = "Mount hovered ISO and open mount manager"; }
            { on = [ "L" ]; run = "plugin fuse-archive -- mount"; desc = "Mount and enter archive/ISO"; }
            { on = [ "H" ]; run = "plugin fuse-archive -- unmount"; desc = "Leave and unmount archive/ISO"; }
            { on = "<Enter>"; run = "plugin iso-mount"; desc = "Open / enter / mount ISO"; }
            { on = "l"; run = "plugin iso-mount"; desc = "Open / enter / mount ISO"; }
            { on = "<Right>"; run = "plugin iso-mount"; desc = "Open / enter / mount ISO"; }
            { on = "h"; run = "plugin iso-mount leave"; desc = "Leave / unmount ISO"; }
            { on = "<Left>"; run = "plugin iso-mount leave"; desc = "Leave / unmount ISO"; }
          ];
        };

        plugins = {
          inherit (pkgs.yaziPlugins) mount;
          iso-mount = iso-mount-yazi;
          fuse-archive = pkgs.fetchFromGitHub {
            owner = "boydaihungst";
            repo = "fuse-archive.yazi";
            rev = "1bc697bf6735bad1af44cd09c875fd421781386f";
            hash = "sha256-ZUU6law+BlFQYCjJrOAkQS3NPaAbcpKEIWGd6RKhKAQ=";
          };
        };
        yaziPlugins = {
          enable = true;
          plugins = {
            rich-preview = {
              enable = true;
            };
            relative-motions = {
              enable = true;
              show_numbers = "relative_absolute";
              show_motion = true;
            };
            ouch = {
              enable = true;
            };
            jump-to-char = {
              enable = true;
              keys.toggle.on = [ "F" ];
            };
            glow = {
              enable = false;
            };
            chmod = {
              enable = true;
            };
          };
        };

      };
    };
}

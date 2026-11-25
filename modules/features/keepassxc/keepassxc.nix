{
  flake.modules.homeManager.keepassxc = { ... }:
    {
      programs = {
        keepassxc = {
          enable = true;
          autoStart = true;
        };
        umbriel = {
          settings = {
            scratchpad = [
              {
                name = "keepass";
                spawn_when_empty = "keepassxc";
              }
            ];
            window_rule = [
              {
                match.app_id = "^org[.]keepassxc[.]KeePassXC$";
                default_scratchpad = "keepass";
                default_floating_size = { width = 0.5; height = 0.6; };
                default_position = { x = 0; y = 0; anchor = "center"; };
              }
            ];
            keybinds = {
              "Mod+Shift+P" = { action = "scratchpad-toggle keepass"; repeat = false; };
            };
          };
        };
      };
    };
}


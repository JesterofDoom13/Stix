{ self, lib, ... }: {
  flake.modules = lib.mkMerge [
    (self.factory.user "Jester" true)
    {
      nixos.Jester = {
        imports = with self.modules.nixos; [
          # developmentEnvironment
        ];
        users.users.Jester = {
          group = "users";
        };
        # services.snapper.configs.home.ALLOW_USERS = [ "Jester" ];
        system.stateVersion = "26.11";
      };

      darwin.Jester = {
        imports = with self.modules.darwin; [
          # drawingApps
          # developmentEnvironment
        ];
      };

      homeManager.Jester = { pkgs, ... }: {
        imports = with self.modules.homeManager; [
        ];
        home = {
          stateVersion = "26.11";
          packages = with pkgs; [
            mediainfo
          ];
          shellAliases = {
            du = "dust";
            q = "exit";
            rsg = "systemctl --user daemon-reload && systemctl --user restart app-ghostty-service.service";
            oswitch = "find ~/.config -name \"*hmup\" -delete && sn && nh os switch";
          };
        };
      };
    }
  ];
}

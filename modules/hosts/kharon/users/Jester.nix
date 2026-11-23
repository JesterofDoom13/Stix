{ inputs, ... }: {
  flake.modules.nixos.kharon =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          Jester
          disko
          openlogi
          gaming
          printing
          umbriel-desktop
          (jovian "Jester" "umbriel")
        ];

      home-manager.users.Jester = { config, ... }:
        let
          mkFolder = inputs.self.lib.syncthing.mkFolder config;
        in
        {
          imports =
            with inputs.self.modules.homeManager;
            [
              syncthing
              umbriel-desktop
            ];
          # Have to add these invidually to each user finding out what the last directory 32 character is when lichii starts
          services.syncthing.settings.folders."lichii-nand" = mkFolder "${config.xdg.dataHome}/lichii/nand/user/save/0000000000000000/12CE9ED5C22FB29C29E255739AF78068" { };
          programs.xbox-cloud-gaming.enable = true;
          home.packages = [
            pkgs.moonlight-qt
            pkgs.pear-desktop
          ];
        };
    };
}

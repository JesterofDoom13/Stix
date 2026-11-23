{ inputs, ... }: {
  flake.modules.nixos.gamix =
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          Jester
          disko
          gaming
          umbriel-desktop
          (jovian "Jester" "umbriel")
        ];

      home-manager.users.Jester =
        { config, ... }:
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
          services.syncthing.settings.folders."lichii-nand" = mkFolder "${config.xdg.dataHome}/lichii/nand/user/save/0000000000000000/6D939F1107CDC4B67F6412651D439A14" { };
          programs.xbox-cloud-gaming.enable = true;
        };
    };
}

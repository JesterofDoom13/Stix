{ inputs, ... }: {
  flake.modules.nixos.kharon =
    { ... }:
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

      home-manager.users.Jester = {
        imports =
          with inputs.self.modules.homeManager;
          [
            syncthing
            umbriel-desktop
          ];
        programs.xbox-cloud-gaming.enable = true;
      };
    };
}

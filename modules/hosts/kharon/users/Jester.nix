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

      home-manager.users.Jester = { ... }:
        {
          imports =
            with inputs.self.modules.homeManager;
            [
              syncthing
              umbriel-desktop
            ];
          programs.xbox-cloud-gaming.enable = true;
          home.packages = [
            pkgs.moonlight-qt
            pkgs.pear-desktop
            pkgs.keepassxc
          ];
          programs.gpg.enable = true;
          services.gpg-agent = {
            enable = true;
            pinentry.package = pkgs.pinentry-egui;
          };
        };
    };
}

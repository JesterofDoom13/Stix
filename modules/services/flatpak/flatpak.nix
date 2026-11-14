{ inputs, ... }:
{
  flake.modules.nixos.flatpak = { config, lib, ... }:
    let
      wantsFlatpak = lib.any
        (u: (u.services.flatpak.packages or [ ]) != [ ])
        (lib.attrValues config.home-manager.users);
    in
    {
      services.flatpak.enable = lib.mkDefault wantsFlatpak;

      # Makes the services.flatpak.* HM options exist for every user
      home-manager.sharedModules = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
    };

  flake.modules.homeManager.flatpak = {
    services.flatpak = {
      enable = true;
      remotes = [{
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }];
      update.onActivation = false;
    };
  };
}

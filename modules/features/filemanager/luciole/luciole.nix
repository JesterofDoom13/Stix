{ inputs, ... }:
{
  flake.modules.nixos.luciole = {
    imports = [ inputs.luciole.nixosModules.default ];

    programs.luciole.enable = true;
    services.gvfs.enable = true;
  };

  flake.modules.homeManager.luciole = {
    imports = [ inputs.luciole.homeModules.default ];

    programs.luciole = {
      enable = true;
      settings = {
        browser = {
          view_mode = "grid";
          show_hidden = false;
        };
      };
    };
  };
}





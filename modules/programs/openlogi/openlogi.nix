{
  flake.modules.nixos.openlogi = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      openlogi
      solaar
    ];
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
  };
}

{ ... }: {
  flake.modules.homeManager.srm = { pkgs, ... }: {
    home.packages = with pkgs; [
      steam-rom-manager
    ];
  };
}

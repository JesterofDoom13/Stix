{
  flake.modules.homeManager.eden = { pkgs, ... }: {
    home.packages = with pkgs; [
      eden
    ];
  };
}

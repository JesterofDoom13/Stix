{ pkgs, ... }:
{
  home.packages = with pkgs; [
    teams-for-linux
    guvcview # For testing the camera
    evolutionWithPlugins
  ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    steam-rom-manager
  ];
}

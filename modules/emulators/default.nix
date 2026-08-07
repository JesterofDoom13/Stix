{ pkgs, ... }:
{
  imports = [
    # ./dolphin.nix
    # ./srm.nix
    ./xbox-cloud-gaming.nix
  ];
  home.packages = with pkgs; [ eden ];
  programs.xbox-cloud-gaming.enable = true;
}

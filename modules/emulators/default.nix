{ pkgs, ... }:
{
  # Switched to retrodeck
  imports = [
    # ./dolphin.nix
    # ./srm.nix
  ];
  home.packages = with pkgs; [ eden ];
}

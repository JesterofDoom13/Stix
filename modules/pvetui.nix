{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.pvetui.packages.${pkgs.system}.default
  ];
}

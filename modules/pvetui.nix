{ pkgs
, ...
}:
{
  home.packages = [
    pkgs.pvetui
    # inputs.pvetui.packages.${pkgs.system}.default
  ];
}

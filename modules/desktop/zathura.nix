{ ... }:
{
  programs.zathura.enable = true;
  xdg.mimeApps = {
    associations.added."applications/pdf" = [ "org.pwmt.zathura.desktop" ];
    defaultApplications."applications/pdf" = [ "org.pwmt.zathura.desktop" ];
  };
}

{ inputs, ... }:
{
  flake.modules.homeManager.office = {
    imports = [ inputs.self.modules.homeManager.flatpak ];
    services.flatpak.packages = [
      "org.libreoffice.LibreOffice"
      "com.github.tchx84.Flatseal"
    ];
  };
}

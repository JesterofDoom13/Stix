{ ... }:
{
  flake.modules.nixos.printing = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      simple-scan
    ];
    programs.system-config-printer.enable = true;
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}

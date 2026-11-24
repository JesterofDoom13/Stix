{ inputs, ... }:
{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      settings.devices = {
        "proxmox-syncthing" = {
          id = "OQXMPN3-3UISNNK-UL2FIJI-ZQQTRUC-ISUBUKO-SVWGF7R-A4SXXUA-I4BEVAJ";
          name = "Proxmox Syncthing";
        };
        "kharon" = {
          id = "6AIQXDY-FVGJH2I-TWWP4GK-EWPAIP7-5NFYARX-VOKYX5I-JZJZVUM-PCKWIQU";
        };
        "gamix" = {
          id = "UC4K5U7-Q7UZ66W-XXRYDDH-CD2Y5UF-WTR46KU-XHNXM22-CMIYXVN-3X7OLAN";
        };
      };
    };
  };

  # Firewall is system-level, so it can't live in HM.
  # Also registers the HM module for every HM user.
  flake.modules.nixos.syncthing = {
    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
    home-manager.sharedModules = [ inputs.self.modules.homeManager.syncthing ];
  };
}

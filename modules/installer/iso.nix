{ self, inputs, ... }:
{
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ({ pkgs, ... }: {
        isoImage.isoName = "stix-kharon.iso";

        # Put the whole built system on the ISO so the install is offline.
        isoImage.storeContents = [
          self.nixosConfigurations.kharon.config.system.build.toplevel
        ];

        # Smaller ISO, slower build. Try level 6 first, go higher if size matters.
        isoImage.squashfsCompression = "zstd -Xcompression-level 12";

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        environment.systemPackages = [ pkgs.git pkgs.parted ];
      })
    ];
  };

  flake.packages.x86_64-linux.iso =
    self.nixosConfigurations.installer.config.system.build.isoImage;
}

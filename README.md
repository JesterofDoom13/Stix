# Stix
My Steam Deck NixOS configurations

Includes:
- Jovian-NixOS 
- Noctalia Shell
- Niri Window Manager
- RetroDeck 
- Syncthing

## Steps to Get Started in NixOS LiveUSB
### Clone Your Config:

```bash
nix-shell -p git
git clone <https://github.com/JesterofDoom13/Stix.git nixos-config
cd nixos-config
```

>[!TIP]
>replace nixos-config with whatever folder you want to call it. 
>I put mine currently in a directory ~/Stix


### Format Disk and Install:

```bash
# Format everything with disko
sudo nix --extra-experimental-features "nix-command flakes" \
    run github:nix-community/disko -- --mode format,mount ./disko.nixK

# Generate hardware config

sudo nixos-generate-config --no-filesystems --root /mnt

# Copy hardware config into your flake

cp /mnt/etc/nixos/hardware-configuration.nix .
git add .

# Increase the open files limit for this session
ulimit -n 65536

# Increase download buffer size in nix config
mkdir -p /etc/nix
echo "download-buffer-size = 536870912" | sudo tee -a /etc/nix/nix.conf

# Also increase for the sudo session
sudo bash -c "ulimit -n 65536 && echo done"

# Restart nix daemon to pick up the config change
sudo systemctl restart nix-daemon

# Install
ulimit -n 65536
sudo TMPDIR=/mnt/tmp nixos-install --flake .#min
sudo reboot
```

>[!TIP]
> Might not need all the ulimit commands anymore since I switched to 
> using cachix pulled kernel. 

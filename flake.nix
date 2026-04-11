{
  description = "Jester's Jovian NixOS Steam Deck config";

  # Left this at the top for anyone who is looking/using this flake
  # can find it easily
  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://jovian.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "jovian.cachix.org-1:8Vq4Txku6VZIRhYrHYki3Ab9XHJRoWmdYqMqj4rB/Uc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri-tweaks = {
      url = "github:heyoeyo/niri_tweaks";
      flake = false; # it's not a flake, just a source
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";

    pvetui.url = "github:devnullvoid/pvetui";

    nix-yazi-plugins.url = "github:lordkekz/nix-yazi-plugins";
    nix-yazi-plugins.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    vimium-options.url = "github:uimataso/vimium-nixos";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    plugins-kanban-nvim = {
      url = "github:arakkkkk/kanban.nvim";
      flake = false;
    };
    plugins-markdownplus = {
      url = "github:yousefhadder/markdown-plus.nvim";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      jovian,
      nix-flatpak,
      home-manager,
      disko,
      niri,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "Jester";
      myStylix = "gruvbox-material-dark-hard";
    in
    {
      nixosConfigurations.min = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            user
            myStylix
            system
            ;
        };
        modules = [
          jovian.nixosModules.default
          niri.nixosModules.niri
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          ./configuration.nix
          ./disko.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit
                  inputs
                  user
                  myStylix
                  system
                  ;
              };
              users.${user} = import ./home.nix;
            };
          }
        ];
      };

      nixosConfigurations.steamdeck = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            user
            myStylix
            system
            ;
        };
        modules = [
          jovian.nixosModules.default
          niri.nixosModules.niri
          nix-flatpak.nixosModules.nix-flatpak
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          ./configuration.nix
          ./disko.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit
                  inputs
                  user
                  myStylix
                  system
                  ;
              };
              users.${user}.imports = [
                ./home.nix
                ./modules/default.nix
              ];
            };
          }
        ];
      };
    };
}

{
  # Zen browser with additionals for plugins
  # https://github.com/0xc000022070/zen-browser-flake
  # https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons
  # https://github.com/uimataso/vimium-nixos

  flake-file.inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    vimium-options.url = "github:uimataso/vimium-nixos";
    vimium-options.inputs.nixpkgs.follows = "nixpkgs";
  };
}

{
  flake-file.inputs.nix-yazi-plugins = {
    url = "github:lordkekz/nix-yazi-plugins";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}

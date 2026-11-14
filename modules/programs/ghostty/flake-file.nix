{
  flake-file = {
    nixConfig = {
      extra-substituters = [
        "https://ghostty.cachix.org"
      ];
      extra-trusted-public-keys = [
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };
    inputs.ghostty = {
      url = "github:ghostty-org/ghostty";
      # inputs.nixpkgs.follows = "nixpkgs"; # If it follows nixpkgs it will compile everytime
    };
  };
}

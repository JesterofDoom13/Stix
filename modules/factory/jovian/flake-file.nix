{
  flake-file = {
    nixConfig = {
      extra-substituters = [
        "https://jovian.cachix.org"
      ];
      extra-trusted-public-keys = [
        "jovian.cachix.org-1:8Vq4Txku6VZIRhYrHYki3Ab9XHJRoWmdYqMqj4rB/Uc="
      ];
    };
    inputs.jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

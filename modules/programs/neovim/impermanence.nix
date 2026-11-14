{ inputs, ... }: {
  flake.modules.homeManager.neovim = { config, ... }: {
    home = inputs.self.lib.mkIfPersistence config {
      persistence."/persist" = {
        directories = [
          ".config/neovim"
        ];
      };
    };
  };
}

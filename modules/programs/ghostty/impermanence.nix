{ inputs, ... }: {
  flake.modules.homeManager.ghostty = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/ghostty"
          ];
        };
      };
    };
}

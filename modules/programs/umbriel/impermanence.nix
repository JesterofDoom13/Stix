{ inputs, ... }: {
  flake.modules.homeManager.umbriel = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/umbriel"
          ];
        };
      };
    };
}

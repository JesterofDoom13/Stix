{ inputs, ... }: {
  flake.modules.homeManager.orca = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/OrcaSlicer"
          ];
        };
      };
    };
}

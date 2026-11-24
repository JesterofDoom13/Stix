{ inputs, ... }: {
  flake.modules.homeManager.lichii = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/lichii"
          ];
        };
      };
    };
}

{ inputs, ... }: {
  flake.modules.homeManager.zathura = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/zathura"
          ];
        };
      };
    };
}

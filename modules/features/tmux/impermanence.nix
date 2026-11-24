{ inputs, ... }: {
  flake.modules.homeManager.tmux = { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/tmux"
          ];
        };
      };
    };
}

{ inputs
, ...
}:
{
  flake.modules.homeManager.shell =
    { config
    , ...
    }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            ".config/fish"
            ".config/bat"
            ".config/btop"
            ".config/git"
            ".config/ripgrep"
            "Workspace"
          ];
          files = [ ".bash_history" ];
        };
      };
    };
}

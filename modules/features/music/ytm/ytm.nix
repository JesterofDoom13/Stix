{ inputs, ... }:
{
  flake.modules.homeManager.ytm = { pkgs, ... }: {

    # nixpkgs.overlays = [ inputs.ytm-player.overlays.default ];

    home.packages = [
      # pkgs.ytm-player # core (MPRIS + album art included)
      inputs.ytm-player.packages.${pkgs.stdenv.hostPlatform.system}.ytm-player-full # all features (Discord, Last.fm, Spotify import)
    ];
  };
}

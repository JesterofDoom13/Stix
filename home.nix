{
  pkgs,
  user,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "25.11";

    shellAliases = {
      du = "dust";
      q = "exit";
      # rsg restarts ghostty service
      rsg = "systemctl --user daemon-reload && systemctl --user restart app-ghostty-service.service";
      oswitch = "sn && nh os switch";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      alacritty
      firefox
    ];
  };

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };
}

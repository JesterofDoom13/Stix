{ pkgs
, user
, ...
}:
{
  # gtk.gtk4.theme = null;
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "26.05";

    shellAliases = {
      du = "dust";
      q = "exit";
      # rsg restarts ghostty service
      rsg = "systemctl --user daemon-reload && systemctl --user restart app-ghostty-service.service";
      oswitch = "find ~/.config -name \"*hmup\" -delete && sn && nh os switch";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      git
    ];
  };

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = false;
    frequency = "weekly";
  };
}

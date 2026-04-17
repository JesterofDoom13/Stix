{ pkgs, inputs, ... }:
let
  mf = pkgs.writeShellScriptBin "mf" ''
    FLAKE_URL="''${1:-$HOME/Workspace/Tools/my-flakes/}"
    template_list=$(${pkgs.nix}/bin/nix flake show "$FLAKE_URL" --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '
      .templates | to_entries[] | "\(.key)\t\(.value.description)"
    ')
    if [[ -z "$template_list" ]]; then
      echo "No templates found in flake: $FLAKE_URL" >&2
      exit 1
    fi
    selection=$(echo "$template_list" | ${pkgs.fzf}/bin/fzf \
      --height=40% \
      --cycle \
      --bind='ctrl-p:up,ctrl-n:down' \
      --delimiter=$'\t' \
      --with-nth=1 \
      --preview='echo {2}' \
      --preview-window='bottom:3:wrap' \
      --prompt="Select Template > ")
    if [[ -n "$selection" ]]; then
      template_name=$(echo "$selection" | cut -f1)
      echo "Initializing template: $template_name..."
      ${pkgs.nix}/bin/nix flake init -t "$FLAKE_URL#$template_name"
      ${pkgs.direnv}/bin/direnv allow
    else
      echo "No template selected."
    fi
  '';
in
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''eval "$(batman --export-env)"'';
    };
    fish = {
      enable = true;
      shellInit = ''
        fish_vi_key_bindings
        batman --export-env | source
        if test -f ~/.config/fish/noctalia-colors.fish
          source ~/.config/fish/noctalia-colors.fish
        end
      '';
      interactiveShellInit = ''
        set fish_greeting
        if status is-interactive; and not set -q TMUX; tmux_smart_attach; end
        function fish_prompt
          # Use the universal variables set by Noctalia
          set_color $my_prompt_color
          echo -n (prompt_pwd)
          set_color $my_prompt_secondary
          if test -n "$IN_NIX_SHELL"
              echo -n (set_color blue)"(nix) " (set_color normal)
          end
          echo -n (fish_git_prompt)
          echo -n " > "
          set_color normal
        end
      '';
      shellAbbrs = {
        cd = "z";
        dock = "fissh root@10.0.0.6";
        cad = "fissh root@10.0.0.154";
        klip = "fissh klip@10.0.0.161";
        ob = "fissh root@10.0.0.218";
        prox = "fissh root@bigprox";
        plex = "fissh root@10.0.0.90";
        pi = "fissh pi@johnny";
        head = "fissh root@10.0.0.94";
        nixi = "fissh Jester@10.0.0.175";
      };
      functions = {
        fissh = "SSH_PREFER_FISH=1 ssh -o SendEnv=SSH_PREFER_FISH $argv";
        tmux_smart_attach = ''
          if not tmux has-session 2>/dev/null; tmux new-session; return; end
          set unattached (tmux list-sessions -F "#{session_attached}" | grep 0)
          if test -z "$unattached"; tmux new-session; else; tmux attach-session; end
        '';
      };
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batman
        batgrep
      ];
    };
    btop = {
      enable = true;
      settings.vim_keys = true;
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      icons = "auto";
    };
    direnv = {
      enable = true;
      silent = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Nicholas Porter";
          email = "JesterofDoom13@gmail.com";
        };
        init.defaultBranch = "main";
      };
    };

    nh = {
      enable = true;
      flake = "/home/Jester/Stix";
      homeFlake = "/home/Jester/Stix";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 2w";
      };
    };
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    nix-index-database.comma.enable = true;
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--max-columns-preview"
      ];
    };
    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };

  home.packages = with pkgs; [
    mf
    gcc
    python3
    ruby
    fd
    dust
    pandoc
    pcsc-tools
    opensc
    nssTools
  ];
}

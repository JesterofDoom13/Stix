{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      fingers
      # Couldn't get this to load from here
      # but I have it installed in neovim so I use
      # the run-shell command on it and that does the
      # trick.
      # pkgs.vimPlugins.tmux-nvim
    ];
    extraConfig = ''
      set -g prefix C-\\
      unbind C-b
      unbind n
      bind-key n new
      set-window-option -g mode-keys vi

      set -g  default-terminal "screen-256color"
      # needed for proper nvim/tmux/base16 colors
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g allow-passthrough on
      set -g visual-activity off

      bind-key r source-file ~/.config/tmux/tmux.conf

      ## Smart-splits loading without plugin. Plugin does the rest in neovim.
      # '@pane-is-vim' is a pane-local option that is set by the plugin on load,
      # and unset when Neovim exits or suspends; note that this means you'll probably
      # not want to lazy-load smart-splits.nvim, as the variable won't be set until
      # the plugin is loaded

      # Smart pane switching with awareness of Neovim splits.
      bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

      # Smart pane resizing with awareness of Neovim splits.
      bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l


      # Kill split
      bind-key -n M-w kill-pane 

      # split windows
      bind-key -n 'C-;' split-window -h -c '#{pane_current_path}'
      bind-key -n C-"'" split-window -v -c'#{pane_current_path}'
      bind-key "j" run-shell "sesh connect \"$(
           sesh list --icons | fzf-tmux -p 80%,70% \
             --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
             --header '  ^a all ^t tmux ^g configs ^d kill ^f find' \
             --bind 'tab:down,btab:up' \
             --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
             --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
             --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
             --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
             # --bind 'ctrl-x:execute(tmux list-sessions -F \'#{session_attached} #{session_name}\' | awk \'/^0/{print $2}\' | xargs -I {} tmux kill-session -t \'{}\')+change-prompt(⚡  )+reload(sesh list --icons)' \
             --preview-window 'right:55%' \
             --preview 'sesh preview {}'
          )\""
    '';
  };
  home.packages = with pkgs; [
    sesh
  ];
}

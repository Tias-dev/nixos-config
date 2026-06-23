{
  flake.modules.homeManager.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      mouse = false;
      escapeTime = 0;
      historyLimit = 5000;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9

        bind M-h select-pane -L
        bind M-l select-pane -R
        bind M-k select-pane -U
        bind M-j select-pane -D

        bind -n M-S-h resize-pane -L 5
        bind -n M-S-l resize-pane -R 5
        bind -n M-S-k resize-pane -U 3
        bind -n M-S-j resize-pane -D 3

        bind -n M-t new-window
        bind -n M-c kill-pane
        bind -n M-q kill-window
        bind M-Q kill-session

        set -gq allow-passthrough on
        set -g visual-activity off
        set-option -g focus-events on

	set -s copy-command 'wl-copy'
      '';
      plugins = with pkgs.tmuxPlugins; [
        tokyo-night-tmux
        {
          plugin = pkgs.tmuxPlugins.tmux-sessionx;
          extraConfig = ''
            set -g @sessionx-bind 'M-o'
            set -g @sessionx-prefix off
            set -g @sessionx-fzf-builtin-tmux 'on'
            set -g @sessionx-tree-mod 'on'
            set -g @sessionx-zoxide-mode 'on'
          '';
        }
        dotbar
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = pkgs.tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15' # minutes
          '';
        }
      ];
    };
  };
}

{
  flake = {
    modules.homeManager.tmux = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options = {
        tmux.server-copy-command.enable = lib.mkEnableOption "server only tmux copy buffer";
      };

      config = {
        programs = {
          sesh = {
            enable = true;
            enableAlias = true;
            enableTmuxIntegration = true;
            icons = true;
            tmuxKey = "f";
          };
          fzf.tmux.enableShellIntegration = true;

          tmux = {
            enable = true;
            baseIndex = 1;
            mouse = false;
            escapeTime = 0;
            historyLimit = 5000;
            clock24 = true;
            keyMode = "vi";
            terminal = "screen-256color";
            extraConfig =
              ''
                bind -n M-1 select-window -t 1
                bind -n M-2 select-window -t 2
                bind -n M-3 select-window -t 3
                bind -n M-4 select-window -t 4
                bind -n M-5 select-window -t 5
                bind -n M-6 select-window -t 6
                bind -n M-7 select-window -t 7
                bind -n M-8 select-window -t 8
                bind -n M-9 select-window -t 9

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

                bind-key l send-keys "clear" \; send-keys "Enter"
                set -g detach-on-destroy off
              ''
              + (
                if config.tmux.server-copy-command.enable
                then "set -s set-clipboard on"
                else "set -s copy-command 'wl-copy'"
              );
            plugins = with pkgs.tmuxPlugins; [
              tokyo-night-tmux
              {
                plugin = dotbar;
                extraConfig = ''
                  set -g @tmux-dotbar-right true
                  set -g @tmux-dotbar-status-right-text " #H "
                  set -g @tmux-dotbar-rounded true
                  set -g @tmux-dotbar-bold-status true
                  set -g @tmux-dotbar-maximized-icon "󰊓"

                  set -g @tmux-dotbar-bg "${config.lib.stylix.colors.withHashtag.base00}"
                  set -g @tmux-dotbar-fg "${config.lib.stylix.colors.withHashtag.base02}"
                  set -g @tmux-dotbar-fg-current "${config.lib.stylix.colors.withHashtag.base0C}"
                  set -g @tmux-dotbar-fg-session "${config.lib.stylix.colors.withHashtag.base0C}"
                  set -g @tmux-dotbar-fg-prefix "${config.lib.stylix.colors.withHashtag.base0C}"
                '';
              }
              vim-tmux-navigator
              {
                plugin = extrakto;
                extraConfig = (
                  if config.tmux.server-copy-command.enable
                  then "set -g @extrakto_clip_tool_run 'tmux_osc52'"
                  else "set -g @extrakto_clip_tool 'wl-copy'"
                );
              }
            ];
          };
        };
      };
    };
  };
}

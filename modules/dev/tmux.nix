{config, ...}: let
  inherit (config.flake.lib) mkTmuxSessionizerPkg mkDefaultTmuxSessionizerSessionNameSelector;
in {
  flake = {
    lib = {
      mkDefaultTmuxSessionizerSessionNameSelector = pkgs:
        pkgs.writers.writeBash "defaultSessionNameSelector"
        /*
        bash
        */
        ''
          selectedEntry="$1"
          basename "$selectedEntry"
        '';
      mkTmuxSessionizerPkg = foldersToSearchScript: sessionNameSelector: {writers}:
        writers.writeBash ''tmux-sessionizer'' ''
          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              entries=$(${foldersToSearchScript})
              selected=$(echo -e "$entries" | fzf)
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(${sessionNameSelector} "$selected" | tr . _)
          tmux_running=$(pgrep tmux)

          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
              tmux new-session -s $selected_name -c $selected
              exit 0
          fi

          if ! tmux has-session -t=$selected_name 2> /dev/null; then
              tmux new-session -ds $selected_name -c $selected
          fi

          tmux switch-client -t $selected_name
        '';
    };
    modules.homeManager.tmux = {
      pkgs,
      lib,
      config,
      ...
    }: let
      tmux-sessionizer-folders = pkgs.writers.writeBash "tmux-sessionizer-folders" ''
        zoxide_most_often=$(${pkgs.zoxide}/bin/zoxide query -ls | head -n 20 | awk '{print $2}')
        entries=$(find ~/git ~/Projects ~/ ~/work -mindepth 1 -maxdepth 1 -type d)
        echo -e "$HOME\n$zoxide_most_often\n$entries"
      '';
      tmux-session-name-selector = mkDefaultTmuxSessionizerSessionNameSelector pkgs;
      tmux-sessionizer = pkgs.callPackage (mkTmuxSessionizerPkg tmux-sessionizer-folders tmux-session-name-selector) {};
    in {
      options = {
        tmux.server-copy-command.enable = lib.mkEnableOption "server only tmux copy buffer";
      };

      config = {
        programs.tmux = {
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

              bind-key -r f run-shell "tmux neww ${tmux-sessionizer}"
              bind-key l send-keys "clear" \; send-keys "Enter"
            ''
            + (
              if config.tmux.server-copy-command.enable
              then "set -s set-clipboard on"
              else "set -s copy-command 'wl-copy'"
            );
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
            vim-tmux-navigator
            {
              plugin = extrakto;
              extraConfig = (
                if config.tmux.server-copy-command.enable
                then "set -g @extrakto_clip_tool_run 'tmux_osc52'"
                else "set -g @extrakto_clip_tool 'wl-copy'"
              );
            }
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
    };
  };
}

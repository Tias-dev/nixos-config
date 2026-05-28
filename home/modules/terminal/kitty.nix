{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      scrollback_lines = 4000;
      scrollbar = "never";
      confirm_os_window_close = 0;

      enable_audio_bell = false;
      bell_on_tab = "🔔 ";
      window_border_width = "0.5pt";
      draw_minimal_borders = true;
      draw_window_borders_for_single_window = false;
      window_margin_width = 0;
      single_window_margin_width = -1;
      window_padding_width = 0;
      single_window_padding_width = -1;
      tab_bar_edge = "bottom";

      tab_bar_style = "powerline";
      background_opacity = 1.0;
      hide_window_decorations = true;

      font_family = "family='JetBrainsMono Nerd Font' postscript_name=JetBrainsMonoNF-Regular";
      bold_font = "family='JetBrainsMono Nerd Font' postscript_name=JetBrainsMonoNF-Bold";
      italic_font = "auto";
      bold_italic_font = "auto";
    };

    extraConfig = ''
      startup_session launch.conf
      		'';

    themeFile = "tokyo_night_moon";
  };
  xdg.configFile."kitty/launch.conf".text = "launch sh -c 'tmux attach || tmux new -s default'";
}

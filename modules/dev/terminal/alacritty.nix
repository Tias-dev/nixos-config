{
  flake.modules.homeManager.alacritty = {
#    config.terminal = {
#      name = "Alacritty";
#      path = "alacritty";
#    };
    programs.alacritty = {
      enable = true;
    };
  };
}

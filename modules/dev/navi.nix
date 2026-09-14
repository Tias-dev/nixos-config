{
  config.flake.modules.homeManager.develop = {
    config,
    lib,
    ...
  }: {
    programs.navi = {
      enable = true;
      enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
      enableFishIntegration = lib.mkIf config.programs.fish.enable true;
      settings = {
        cheats = {
          paths = [
            (toString ../../docs/cheats)
            "$HOME/.local/share/navi/cheats"
          ];
        };
      };
    };
    programs.tmux = lib.mkIf config.programs.tmux.enable {
      extraConfig = ''
        bind-key -N "Open Navi (cheat sheets)" -T prefix C-g split-window \
        "$SHELL --login -i -c 'navi --print | tmux load-buffer -b tmp - ; tmux paste-buffer -p -t {last} -b tmp -d'"
      '';
    };
  };
}

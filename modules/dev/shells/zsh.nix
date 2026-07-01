{
  flake.modules.homeManager.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "aliases"
          "alias-finder"
          "docker"
          "docker-compose"
          "kitty"
          "tmux"
        ];
        theme = "robbyrussell";
        extraConfig = ''
          zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
          zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
          zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
          zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
        '';
      };
      history.append = true;
      shellAliases = {
        nxs = "sudo nixos-rebuild switch --flake ~/nix/#$(hostname)";
        hms = "home-manager switch --flake ~/nix/#$(hostname)";

        vi = "nvim";
        v = "nvim";

        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lla = "lsd -la";

        spf = "superfile";

        cat = "bat";
        less = "bat";

        top = "btop";
        htop = "btop";
        cd = "z";
      };
    };
    home.shell.enableZshIntegration = true;
  };

  flake.modules.nixos.zsh = {pkgs, username, ...}: {
    environment.pathsToLink = ["/share/zsh"];
    users.users.${username}.shell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}

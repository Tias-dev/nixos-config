{
  flake.modules.homeManager.zsh = {
    pkgs,
    lib,
    ...
  }: {
    programs.zsh = let
      zsh-fzf-search = pkgs.fetchFromGitHub {
        owner = "joshskidmore";
        repo = "zsh-fzf-history-search";
        rev = "35df458f7d9478fa88c74af762dcd296cdfd485d";
        hash = "sha256-6UWmfFQ9JVyg653bPQCB5M4jJAJO+V85rU7zP4cs1VI";
      };
    in {
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
        ];
        theme = "robbyrussell";
        extraConfig = ''
          zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
          zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
          zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
          zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
        '';
      };
      history = {
          append = true;
          saveNoDups = true;
      };
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

      # extra plugins source
      # aka add to the end of .zshrc
      initContent = lib.mkAfter ''
        source ${zsh-fzf-search}/zsh-fzf-history-search.plugin.zsh
      '';
    };
    home.shell.enableZshIntegration = true;
  };

  flake.modules.nixos.zsh = {
    pkgs,
    username,
    ...
  }: {
    environment.pathsToLink = ["/share/zsh"];
    users.users.${username}.shell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}

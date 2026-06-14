{
  flake.modules.homeManager.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
        ];
        theme = "robbyrussell";
      };
      history.append = true;
      shellAliases = {
        nxs = "sudo nixos-rebuild switch --flake ~/nix/#$(hostname)";
        hms = "home-manager switch --flake ~/nix/#$(hostname)";

        vi = "nvim";
        v = "nvim";

        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gd = "git diff";
        gb = "git branch";

        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lla = "lsd -la";

        spf = "superfile";

        cat = "bat";

        top = "btop";
        htop = "btop";
        cd = "z";

        d = "docker";
        db = "docker build";
        de = "docker exec";
        dr = "docker run";
        dp = "docker pull";
        dl = "docker logs";
        di = "docker image";

        dc = "docker compose";
        dcb = "docker compose build";
        dce = "docker compose exec";
        dcr = "docker compose run";
        dcl = "docker compose logs";
        dcu = "docker compose up";
        dcd = "docker compose down";
      };
    };
    home.shell.enableZshIntegration = true;
  };

  flake.modules.nixos.zsh = {pkgs, ...}: {
    environment.pathsToLink = ["/share/zsh"];
    users.users.raison.shell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}

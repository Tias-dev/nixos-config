{
  flake.modules.homeManager.fish = {pkgs, ...}: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        zoxide init fish | source
      '';
      plugins = [
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
      shellAliases = {
        nxs = "sudo nixos-rebuild switch --flake ~/nix/";
        hms = "home-manager switch --flake ~/nix/";

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
    home.shell.enableFishIntegration = true;
  };

  flake.modules.nixos.fish = {pkgs, config, ...}:
  let
    username = config.flake.modules.homeManager.home.username;
  in {
    users.users.${username}.shell = pkgs.fish;
    programs.fish.enable = true;
  };
}

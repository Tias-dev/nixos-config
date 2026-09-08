{
  flake.modules.homeManager.develop = {lib, config, ...}: let
    gitAliases = {
      gdtl = "git difftool";
    };
  in {
    programs.git = {
      enable = true;
      lfs = {
        enable = true;
        skipSmudge = true;
      };
      includes = [
        {
          contents = {
            user = {
              email = "timur.buchkin@mail.ru";
              name = "Timur Buchkin";
            };
            pull.rebase = true;
            merge.tool = "nvimdiff";
            diff.tool = "nvimdiff";
            mergetool = {
              prompt = true;
              nvimdiff.cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
            };
            difftool = {
              prompt = false;
              nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
            };
          };
        }
      ];
    };
    programs.zsh = lib.mkIf config.programs.zsh.enable {shellAliases = gitAliases;};
    programs.fish = lib.mkIf config.programs.fish.enable {shellAliases = gitAliases;};
  };
}

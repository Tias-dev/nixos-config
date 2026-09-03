{
  flake.modules.homeManager.develop = {
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
              nvimdiff.cmd = "nvim -d $LOCAL $REMOTE $MERGED";
            };
            difftool = {
              prompt = false;
              nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
            };
          };
        }
      ];
    };
  };
}

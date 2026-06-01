{
  flake.modules.homeManager.homeManager = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

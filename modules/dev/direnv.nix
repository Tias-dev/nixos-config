{
  flake.modules.homeManager.develop = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}

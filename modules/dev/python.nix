{
  config.flake.modules.homeManager.develop = {pkgs, ...}: {
    home.packages = with pkgs; [python3];
  };
}

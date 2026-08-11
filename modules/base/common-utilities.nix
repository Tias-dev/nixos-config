{
  config.flake.modules.homeManager.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [busybox];
  };
}

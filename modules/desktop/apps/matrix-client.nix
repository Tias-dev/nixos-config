{
  config.flake.modules.homeManager.matrix-client = {pkgs, ...}: {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}

{
  flake.modules.homeManager.recording = {pkgs, ...}: {
    home.packages = [pkgs.obs-studio];
  };
}

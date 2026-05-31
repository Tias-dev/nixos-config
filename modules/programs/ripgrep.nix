{
  flake.modules.homeManager.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.ripgrep];
  };
}


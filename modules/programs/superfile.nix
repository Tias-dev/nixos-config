{
  config.flake.modules.homeMananger.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [superfile];
  };
}

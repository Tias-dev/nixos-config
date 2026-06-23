{
  config.flake.modules.homeManager."hosts/archer" = {pkgs, ...}: {
    home.packages = with pkgs; [home-manager wl-clipboard];
  };
}

{
  flake.modules.nixos.desktop = {
    programs.xwayland.enable = true;
    services.xserver.enable = true;
  };
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [xwayland-satellite];
  };
}

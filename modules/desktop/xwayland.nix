{inputs, ...}: {
  flake.modules.nixos.desktop = {
    programs.xwayland.enable = true;
    services.xserver.enable = true;
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [xwayland-satellite];
  };

  flake.modules.systemManager.desktop = {
    pkgs,
    system,
    ...
  }: {
    environment.systemPackages = with pkgs; [xwayland-satellite];
  };
}

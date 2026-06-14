{
  flake.modules.nixos.desktop = {
    programs.xwayland.enable = true;
    services.xserver.enable = true;
  };
}

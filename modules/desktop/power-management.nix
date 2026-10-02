{
  flake.modules.nixos.desktop = {
    powerManagement.enable = true;
    powerManagement.powertop.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };
}

{
  flake.modules.nixos.desktop = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}

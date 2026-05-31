{
  flake.modules.nixos.nixos = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}

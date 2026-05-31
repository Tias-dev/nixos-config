{
  flake.modules.nixos.nixos = {
    security.polkit.enable = true;
  };
}

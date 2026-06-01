{
  flake.modules.nixos.nixos = {
    users.users.raison = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };
}

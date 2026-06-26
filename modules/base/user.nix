{username,...}: {
  flake.modules.nixos.nixos = {
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };
}

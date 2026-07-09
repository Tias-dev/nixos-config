{username, ...}: {
  flake.modules.nixos.nixos = {username, ...}: {
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };
}

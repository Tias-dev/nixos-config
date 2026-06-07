{
  flake.modules.nixos.nixos = {config, ...}:
  let
    username = config.flake.modules.homeManager.home.username;
  in {
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };
}

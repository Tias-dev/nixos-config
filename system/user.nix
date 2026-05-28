{
  pkgs,
  username,
  ...
}: {
  users = {
    defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker" "scanner" "lp"];
    };
  };
}

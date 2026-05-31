{
  flake.modules.nixos.nixos = {pkgs, ...}: {
    users.users.raison = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
      shell = pkgs.fish;
    };
    programs.fish.enable = true;
  };
}

{
  flake.modules.nixos.desktop = {username, ...}: {
    services.libinput.enable = true;
    users.users.${username}.extraGroups = ["input"];
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = [pkgs.libinput];
  };
}

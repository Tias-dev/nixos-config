{ config, ... }:
{
  flake.modules.homeManager.niri = {
    programs.niri = {
      enable = true;
      hotkey-overlay.skip-at-startup = true;
      imports = [
	config.flake.modules.homeModules.niri
      ];
    };
  };

  flake.modules.nixos.niri = {
    programs.niri = {
      enable = true;
    };
    imports = [
      config.flake.modules.nixosModules.niri
    ];
  };
}

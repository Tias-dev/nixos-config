{
  inputs,
  config,
  ...
}: {
  flake.modules.homeManager.niri = {pkgs, ...}: let
    niri-settings =
      (pkgs.lib.evalModules {
        modules = [
          config.flake.modules.generic.niri
          {
            options.settings = with pkgs.lib;
              mkOption {
                type = types.lazyAttrsOf types.raw;
                default = {};
              };
          }
        ];
        specialArgs = {inherit pkgs;};
      }).config.settings;
  in {
    programs.niri = {
      enable = true;
      settings = niri-settings;
    };
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms.homeModules.niri
      inputs.dms-plugin-registry.homeModules.default
      inputs.niri.homeModules.niri
    ];
  };

  flake.modules.nixos.niri = {
    programs.niri = {
      enable = true;
    };
  };
}

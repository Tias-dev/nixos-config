{
  inputs,
  config,
  ...
}: {
  flake.modules.homeManager.niri = {
    programs.niri = {
      enable = true;
      settings = config.flake.modules.homeModules.niri;
    };
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms.homeModules.niri
      inputs.dms-plugin-registry.modules.default
      inputs.niri.homeModules.niri
    ];
  };

  flake.modules.nixos.niri = {
    programs.niri = {
      enable = true;
    };
  };
}

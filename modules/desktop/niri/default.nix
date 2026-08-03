{inputs, ...}: {
  config.flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options = {
      niri-settings = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = {};
      };
    };

    config = {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
        settings = config.niri-settings;
      };
    };

    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms.homeModules.niri
      inputs.dms-plugin-registry.homeModules.default
      inputs.niri.homeModules.niri
    ];
  };

  config.flake.modules.nixos.niri = {
    programs.niri = {
      enable = true;
    };
  };

  config.flake.modules.systemManager.niri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [niri];
  };
}

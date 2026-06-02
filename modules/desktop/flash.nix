{config, ...}: let
  inherit (config.flake.meta) fileManager;
in {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    services.udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = fileManager.binPath pkgs;
        };
      };
    };
  };
}

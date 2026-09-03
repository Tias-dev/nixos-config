{lib, ...}: let
  inherit (lib) types mkOption;
  monitorType = types.submodule {
    options = {
      name = mkOption {type = types.str;};
      mode = mkOption {
        type = types.submodule {
          options = {
            width = mkOption {
              type = types.int;
              default = 1920;
            };
            height = mkOption {
              type = types.int;
              default = 1080;
            };
            refresh = mkOption {
              type = types.number;
              default = 60.0;
            };
          };
        };
      };
      extraNiriSettings = mkOption {type = types.lazyAttrsOf types.raw;};
    };
  };
in {
  options.flake.desktop.secondary-monitors = mkOption {
    type = types.listOf monitorType;
    default = [];
    description = "secondary monitors that can be attached everywhere in you life";
  };
  config.flake = {
    modules.homeManager.desktop = {
      options = {
        desktop.primary-monitor = mkOption {
          type = monitorType;
          default = {
            name = "eDP-1";
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.0;
            };
          };
          description = "Primary monitor unique per host(for laptop it is laptop monitor)";
        };
        desktop.secondary-monitor-name = mkOption {
          type = types.nullOr types.str;
          description = "Name of the common second monitor used with this host(must be in config.flake.desktop.secondary-monitors)";
        };
      };
    };
  };
}

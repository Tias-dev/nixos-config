{inputs, ...}: {
  config.flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
      lazyAttrs-type = lib.types.lazyAttrsOf lib.types.raw;
      listOfRaw-type = lib.types.listOf lib.types.raw;
    in {
    options = {
      niri-settings = lib.mkOption {
        type = lib.types.submodule {
          options = {
            binds = lib.mkOption {
              type = lazyAttrs-type;
            };
            input = lib.mkOption {
              type = lazyAttrs-type;
            };
            outputs = lib.mkOption {
              type = lazyAttrs-type;
            };
            spawn-at-startup = lib.mkOption {
              type = listOfRaw-type;
            };
            window-rules = lib.mkOption {
              type = listOfRaw-type;
            };
            workspaces = lib.mkOption {
              type = lazyAttrs-type;
            };
            hotkey-overlay = lib.mkOption {
              type = lazyAttrs-type;
            };
          };
        };
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

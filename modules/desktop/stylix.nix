{inputs, ...}: let
  genThemes = pkgs: {
    dark = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/0x96f.yaml";
      polarity = "dark";
    };
    light = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-nt-light.yaml";
      polarity = "light";
    };
  };
in {
  config.flake.modules.nixos.desktop = {
    username,
    lib,
    config,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    config = {
      # allow users on desktop do nixos-rebuild without sudo in order to
      # allow home-manager based themes change in darkman service
      security.sudo = {
        extraRules = [
          {
            users = [username];
            commands = [
              {
                command = "/run/current-system/sw/bin/nixos-rebuild";
                options = ["NOPASSWD"];
              }
            ];
          }
        ];
      };

      # propagate specialisations to home-manager
      specialisation = {
        light.configuration = {
          home-manager.users.${username}.current-theme = "light";
        };
        dark.configuration = {
          home-manager.users.${username}.current-theme = "dark";
        };
      };
    };
  };

  config.flake.modules.homeManager.homeManager = {
    pkgs,
    config,
    lib,
    home-manager-standalone,
    ...
  }: let
    themes = genThemes pkgs;
  in {
    options = {
      current-theme = lib.mkOption {
        type = lib.types.enum ["dark" "light"];
        default = "dark";
      };
    };

    imports = [
      inputs.stylix.homeModules.stylix
    ];

    config = {
      stylix =
        {
          enable = true;

          targets = {
            firefox.profileNames = ["tias-dev"];
          };
        }
        // themes.${config.current-theme};

      specialisation = lib.mkIf home-manager-standalone {
        light.configuration = {
          current-theme = "light";
        };
        dark.configuration = {
          current-theme = "dark";
        };
      };
    };
  };
}

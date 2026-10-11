{inputs, ...}: {
  config.flake.modules.nixos.desktop = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };

  config.flake.modules.homeManager.homeManager = {
    pkgs,
    lib,
    username,
    home-manager-standalone,
    ...
  }: let
    themes = {
      dark = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/0x96f.yaml";
        polarity = "dark";
      };
      light = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-nt-light.yaml";
        polarity = "light";
      };
    };
    forceAttrs = lib.mapAttrs (_: value: lib.mkForce value);
  in {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix =
      {
        enable = true;

        targets = {
          firefox.profileNames = ["tias-dev"];
        };
      }
      // (lib.mapAttrs (_: value: lib.mkDefault value) themes.dark);

    specialisation = {
      light.configuration = {
        stylix = forceAttrs themes.light;
      };
      dark.configuration = {
        stylix = forceAttrs themes.dark;
      };
    };

    # # automatically switch themes
    services.darkman = {
      enable = true;
      settings = {
        lat = 55;
        lng = 37;
        dbusserver = true;
        portal = true;
      };
      lightModeScripts = {
        "update-dbus" = ''
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';

        "update-home-manager-dms" = lib.mkIf home-manager-standalone ''
          home-manager switch --flake /home/${username}/nix#$(hostname) --specialisation light
          systemctl --user restart dms.service
        '';

        "update-nixos" = lib.mkIf (!home-manager-standalone) ''
          if ! nixos-rebuild --help &>/dev/null; then
            notify-send "Nixos not found, that strange"
            exit 0
          fi
          nixos-rebuild switch --flake /home/${username}/nix#$(hostname) --specialisation light
        '';
      };
      darkModeScripts = {
        "update-dbus" = ''
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';

        "update-home-manager" = lib.mkIf home-manager-standalone ''
          home-manager switch --flake /home/${username}/nix#$(hostname) --specialisation dark
          systemctl --user restart dms.service
        '';

        "update-nixos" = lib.mkIf (!home-manager-standalone) ''
          if ! nixos-rebuild --help &>/dev/null; then
            notify-send "Nixos not found, that strange"
            exit 0
          fi
          nixos-rebuild switch --flake /home/${username}/nix#$(hostname) --specialisation dark
        '';
      };
    };
  };
}

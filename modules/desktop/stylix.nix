{inputs, ...}: {
  config.flake.modules.nixos.desktop = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };

  config.flake.modules.homeManager.homeManager = {pkgs, ...}: {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      polarity = "dark";

      targets = {
        firefox.profileNames = ["tias-dev"];
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
      };
      darkModeScripts = {
        "update-dbus" = ''
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
      };
    };
  };
}

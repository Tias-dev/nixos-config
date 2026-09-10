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

    # automatically switch themes
    systemd.user.services."darkman" = {
      Unit = {
        Description = "Framework for dark-mode and light-mode transitions.";
        Documentation = "man:darkman(1)";
      };
      Service = {
        Type = "dbus";
        BusName = "nl.whynothugo.darkman";
        ExecStart = "${pkgs.darkman}/bin/darkman run";
        Restart = "on-failure";
        TimeoutStopSec = 15;
        Slice = "background.slice";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
    home.packages = with pkgs; [darkman];
    home.file.".config/darkman/config.yaml".text =
      /*
      yaml
      */
      ''
        lat: 55
        lng: 37
        dbusserver: true
        portal: true
      '';
  };
}

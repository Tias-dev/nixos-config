{inputs, ...}: {
  config.flake.modules.nixos.desktop = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };

  config.flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
      polarity = "dark";

      targets = {
        firefox.profileNames = ["tias-dev"];
      };
    };
  };
}

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
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      polarity = "light";

      targets = {
        firefox.profileNames = ["tias-dev"];
      };
    };
  };
}

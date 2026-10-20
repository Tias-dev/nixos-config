{inputs, ...}: {
  config.flake.modules = {
    nixos.mac-tahoe = {
      imports = [inputs.mac-tahoe.nixosModules.defaults];

      services.displayManager.plasma6.enable = true;
      services.mac-tahoe.enable = true;
      services.mac-tahoe.plymouth.enable = true;
    };
    homeManager.mac-tahoe = {lib, ...}: {
      imports = [
        inputs.mac-tahoe.homeManagerModules.default
        inputs.mac-tahoe.homeManagerModules.plasma-manager
      ];
      programs.mac-tahoe = {
        enable = true;
        mode = "auto";
        appleAssets = true;
        oledCare.enable = true;

        panels = {
          enable = true;
          launchers = [
            "applications:org.kde.dolphin.desktop"
          ];
        };
      };

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) ["mac-tahoe-apple-assets"];
    };
  };
}

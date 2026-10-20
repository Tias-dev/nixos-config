{inputs, ...}: {
  config.flake.modules = {
    nixos.mac-tahoe = {
      imports = [inputs.mac-tahoe.nixosModules.default];

      boot.plymouth.enable = true;
      services = {
        desktopManager.plasma6.enable = true;
        displayManager.plasma-login-manager.enable = true;
        mac-tahoe.enable = true;
        mac-tahoe.plymouth.enable = true;
      };
      disable-stylix = true;
    };

    homeManager.mac-tahoe = {lib, ...}: {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.mac-tahoe.homeManagerModules.default
        inputs.mac-tahoe.homeManagerModules.plasma-manager
      ];
      disable-stylix = true;

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

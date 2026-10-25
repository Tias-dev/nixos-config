{inputs, ...}: {
  config.flake.modules = {
    nixos.mac-tahoe-plasma = {
      custom-greeter = true;
      imports = [inputs.mac-tahoe-plasma.nixosModules.default];

      boot.plymouth.enable = true;
      services = {
        desktopManager.plasma6.enable = true;
        displayManager.plasma-login-manager.enable = true;
        mac-tahoe.enable = true;
        mac-tahoe.plymouth.enable = true;
      };
    };

    homeManager.mac-tahoe-plasma = {lib, ...}: {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.mac-tahoe-plasma.homeManagerModules.default
        inputs.mac-tahoe-plasma.homeManagerModules.plasma-manager
      ];
      stylix.enable = lib.mkForce false;
      programs.plasma.immutableByDefault = false;

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

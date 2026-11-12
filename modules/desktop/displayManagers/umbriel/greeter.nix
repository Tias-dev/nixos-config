{inputs, ...}: {
  config.flake.modules.nixos.umbriel = {pkgs, ...}: {
    tui-greeter.enable = false;

    imports = [inputs.noctalia-greeter.nixosModules.default];
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = pkgs.bibata-cursors;
        };
      };
    };
  };
}

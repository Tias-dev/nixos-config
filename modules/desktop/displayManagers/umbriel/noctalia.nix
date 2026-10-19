{inputs, ...}: {
  config.flake.modules.homeManager.umbriel = {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
      };
    };
    programs.umbriel.settings = {
        general = {
          autostart = ["noctalia"];
        };
    };
  };
}

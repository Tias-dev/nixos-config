{inputs, ...}: {
  config.flake.modules.homeManager.umbriel = {
    config,
    system,
    ...
  }: {
    config = {
      xdg.portal = {
        extraPortals = [inputs.xdg-desktop-portal-umbriel.packages.${system}.default];
        configPackages = [ config.programs.umbriel.package ];
      };
    };
  };
}

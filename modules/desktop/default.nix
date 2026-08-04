{inputs, ...}: {
  config.flake.modules.systemManager.desktop = {
    system,
    lib,
    ...
  }: {
    config = {
      environment.systemPackages = [inputs.nixgl.packages.${system}.nixGLDefault];
    };
  };
}

{
  inputs,
  ...
}: {
  config.flake.modules.homeManager.develop = {system, ...} : {
    home.packages = [inputs.nixpkgs-unstable.legacyPackages.${system}.tuxedo];
  };
}

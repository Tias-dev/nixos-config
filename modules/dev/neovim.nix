{inputs, ...}: {
  flake.modules.homeManager.develop = {pkgs,...}: {
    home.packages = [inputs.tias-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}

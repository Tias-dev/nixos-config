{
  flake.modules.homeModules.neovim = {inputs', ...}: {
    home.packages = [inputs'.tias-nixvim.packages.default];
  };
}

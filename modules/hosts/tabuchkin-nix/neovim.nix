{inputs, ...}: {
  config.flake.modules.homeManager."hosts/tabuchkin-nix" = {system, ...}: let
    neovim = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
      clangd.disable-indexing = true;
      all-langs.enable = true;
    };
  in {
    neovim-package = neovim;
  };
}

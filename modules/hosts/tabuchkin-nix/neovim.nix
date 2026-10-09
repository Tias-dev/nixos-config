{
  configurations-lib,
  inputs,
  ...
}: {
  config = configurations-lib.personalHomeManagerModule {
    hostname = "tabuchkin-nix";
    module = {system, ...}: {
      neovim-package = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
        clangd.disable-auto-import = true;
        all-langs.enable = true;
      };
    };
  };
}

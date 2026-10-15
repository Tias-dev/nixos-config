{
  configurations-lib,
  inputs,
  ...
}: {
  config = configurations-lib.personalHomeManagerModule {
    hostname = "laptop-raison";
    module = {system, ...}: {
      neovim-package = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
        all-langs.enable = true;
      };
    };
  };
}

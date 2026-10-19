{
  configurations-lib,
  inputs,
  ...
}: {
  config = configurations-lib.personalHomeManagerModule {
    hostname = "laptop-tias";
    module = {system, ...}: {
      neovim-package = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
        all-langs.enable = true;
        langChanger.enable = false;
      };
    };
  };
}

{
  inputs,
  configurations-lib,
  ...
}: {
  config = configurations-lib.personalHomeManagerModule {
    hostname = "sdg-robot-bl-vla.vla.yp-c.yandex.net";
    module = {
      system,
      pkgs,
      ...
    }: let
      neovim-common-opts = {
        clangd.disable-auto-import = true;
        langChanger.enable = false;
        format.on_save.enable = false;

        cpp.indent-namespace = true;

        all-langs.enable = true;
      };
      neovim =
        inputs.tias-nixvim.lib.neovimWithChangedOptions system
        ({
            clangd.disable-indexing = true;
          }
          // neovim-common-opts);
      indexing-neovim =
        inputs.tias-nixvim.lib.neovimWithChangedOptions system
        ({
            clangd.disable-indexing = false;
          }
          // neovim-common-opts);
    in {
      tmux.server-copy-command.enable = true;
      neovim-package = neovim;
      home.packages = with pkgs; [
        (writers.writeBashBin "ivim"
          /*
          bash
          */
          ''
            ${indexing-neovim}/bin/nvim "$@"
          '')
      ];
    };
  };
}

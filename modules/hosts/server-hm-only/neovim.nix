{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    neovim-common-opts = {
      clangd.disable-auto-import = true;
      langChanger.enable = false;
      format.on_save.enable = false;

      yaml.enable = true;
      cpp.indent-namespace = true;
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
}

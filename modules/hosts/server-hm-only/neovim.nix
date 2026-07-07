{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    neovim = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
      clangd.disable-indexing = true;
      langChanger.enable = false;
      format.on_save.enable = false;
    };
  in {
    config = {inherit neovim;};
  };
}

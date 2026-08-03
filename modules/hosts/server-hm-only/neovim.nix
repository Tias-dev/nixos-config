{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    neovim = inputs.tias-nixvim.lib.neovimWithOverrides system [
      {
        clangd.disable-indexing = true;
        langChanger.enable = false;
        format.on_save.enable = false;
      }
      {
        plugins.lsp.servers.clangd.settings = {
          root_markers = ["compile-commands.json"];
        };
      }
    ];
  in {
    config = {inherit neovim;};
  };
}

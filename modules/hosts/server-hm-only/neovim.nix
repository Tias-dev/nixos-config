{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    neovim = inputs.tias-nixvim.lib.neovimWithOverrides system [
      {
        clangd.disable-indexing = true;
        clangd.disable-auto-import = true;
        langChanger.enable = false;
        format.on_save.enable = false;

        yaml.enable = true;
        cpp.indent-namespace = true;
      }
    ];
  in {
    config = {inherit neovim;};
  };
}

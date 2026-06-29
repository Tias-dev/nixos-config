{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {pkgs, ...}: let
    neovim = inputs.tias-nixvim-no-clangd-indexing.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    programs.home-manager.enable = true;
    home.packages = [ neovim ];
  };
}

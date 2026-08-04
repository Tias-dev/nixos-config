{inputs, ...}: {
  config.flake.modules.homeManager."hosts/tabuchkin-nix" = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    neovim = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
      clangd.disable-indexing = true;
      yaml.enable = true;
    };
  in {
    inherit neovim;
  };
}

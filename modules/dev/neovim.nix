{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    pkgs,
    lib,
    config,
    ...
  }: let
    neovim = inputs.tias-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    options.neovim = lib.mkOption {
      type = lib.types.package;
      default = neovim;
    };
    config = {
      home.packages = [config.neovim];
      programs.zsh.sessionVariables.EDITOR = "nvim";
    };
  };
}

{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    lib,
    config,
    system,
    ...
  }: let
    neovim = inputs.tias-nixvim.lib.neovimWithOverrides system [
      {
        all-langs.enable = true;
      }
    ];
  in {
    options.neovim-package = lib.mkOption {
      type = lib.types.package;
      default = neovim;
    };
    config = {
      home.packages = [config.neovim-package];
      programs.zsh.sessionVariables.EDITOR = "nvim";
    };
  };
}

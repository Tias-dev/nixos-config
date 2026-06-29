{inputs, ...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: let
    neovim = inputs.tias-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [neovim];
    programs.zsh.sessionVariables.EDITOR = "nvim";
  };
  flake.modules.homeManager.neovim-no-clangd-index = {pkgs, ...}: let
      neovim = inputs.tias-nixvim-no-clangd-indexing.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [neovim];
    programs.zsh.sessionVariables.EDITOR = "nvim";
  };
}

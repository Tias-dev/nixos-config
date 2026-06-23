{inputs, ...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: let
    neovim = inputs.tias-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [neovim];
    programs.zsh.sessionVariables.EDITOR = "nvim";
  };
}

{inputs, ...}: {
  flake.modules.homeManager.develop = {pkgs, ...}: let
    neovim = inputs.tias-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [neovim];
    programs.zsh.sessionVariables.EDITOR = "nvim";
  };
}

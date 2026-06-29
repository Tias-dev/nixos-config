{inputs, ...}: {
  flake.modules.homeManager."hosts/server-hm-only" = {pkgs, ...}: let
    neovim = inputs.tias-nixvim-no-clangd-indexing.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [neovim];
    programs.zsh.sessionVariables.EDITOR = "nvim";
  };
}


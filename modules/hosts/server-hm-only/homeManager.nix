{inputs, ...}: {
  config.flake.modules.homeManager."hosts/sdg-robot-bl-vla" = {pkgs, ...}: let
    neovim = inputs.tias-nixvim-no-clangd-indexing.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    programs.home-manager.enable = true;
    home.packages = [
      neovim.overrideAttrs
      (prev: final: {
        config.plugins.lsp.servers.clangd.cmd = [
          "clangd"
          "--clang-tidy"
          "--header-insertion=iwyu"
          "--completion-style=detailed"
          "--function-arg-placeholders"
          "--fallback-style=llvm"
        ];
      })
    ];
  };
}

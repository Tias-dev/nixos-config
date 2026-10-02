{
  config,
  lib,
  ...
}: let
  modules = [
    "ownProxy"
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "neovim"
    "zsh"
    "alacritty"
    "tmux"
    "docker"

    "browser"
  ];
in {
  config = lib.mkMerge [
    (config.flake.lib.mkSystems.linuxHomeManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
    (config.flake.lib.mkSystems.linuxSystemManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
  ];
}

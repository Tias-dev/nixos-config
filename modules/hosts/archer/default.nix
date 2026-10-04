{
  config,
  configurations-lib,
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
    (( configurations-lib.mkSystems config).linuxHomeManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
    (( configurations-lib.mkSystems config).linuxSystemManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
  ];
}

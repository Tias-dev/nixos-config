{
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
    (configurations-lib.mkSystems.linuxHomeManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
    (configurations-lib.mkSystems.linuxSystemManager
      {
        username = "raison";
        hostname = "archer";
        inherit modules;
      })
  ];
}

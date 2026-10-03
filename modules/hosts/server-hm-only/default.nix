{
  configurations-lib,
  lib,
  ...
}: let
  modules = [
    "develop"
    "neovim"
    "zsh"
    "tmux"
    "arc"
  ];
in {
  config = lib.mkMerge [
    (configurations-lib.mkSystems.linuxHomeManager {
      username = "tabuchkin";
      hostname = "sdg-robot-bl-vla.vla.yp-c.yandex.net";
      inherit modules;
    })
  ];
}

{
  config,
  lib,
  ...
}: let
  modules = [
    "efiBoot"
    "sops"
    "xray-client"
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "neovim"
    "zsh"
    "kitty"
    "alacritty"
    "tmux"
    "docker"
    "forgejo-client"
    "deploy"

    "browser"
    "recording"
    "torrent"
    "documents"
    "matrix-client"
    "rutranslit"
  ];
in {
  config = lib.mkMerge [
    (config.flake.lib.mkSystems.linux {
      hostname = "laptop-raison";
      username = "raison";
      inherit modules;
    })
    (config.flake.lib.personalHomeManagerModule {
      hostname = "laptop-raison";
      module = {
        desktop = {
          primary-monitor = {
            name = "AU Optronics 0xE0B2 Unknown";
            mode = {
              width = 1920;
              height = 1080;
              refresh = 165.0;
            };
            extraNiriSettings = {
              scale = 1;
            };
          };
          secondary-monitor-name = "HDMI-A-2";
        };
      };
    })
    # extra flake opts
    {
      ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJC7ayh2luEr8pPQ/TZGAu52lPQimTyTJLnn2X08W0m raison@laptop-raison"
      ];
    }
  ];
}

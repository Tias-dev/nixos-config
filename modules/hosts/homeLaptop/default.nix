{
  configurations-lib,
  lib,
  config,
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
    "mai-wifi-login"
  ];
in {
  config = lib.mkMerge [
    ((configurations-lib.mkSystems config).linux {
      hostname = "laptop-tias";
      username = "tias";
      inherit modules;
    })
    (configurations-lib.personalHomeManagerModule {
      hostname = "laptop-tias";
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
      flake.ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICx5NtGFqXj14jHKzORv2h7ugdDocSwOc7QaznKSDnn9 tias@laptop-tias"
      ];
    }
  ];
}

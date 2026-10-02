{
  config,
  lib,
  ...
}: let
  modules = [
    "desktop"
    "niri"
    "swaylock"
    "bluetooth"
    "sops"
    "mai-wifi-auto-login"

    "develop"
    "arc"
    "ai"
    "zsh"
    "neovim"
    "kitty"
    "alacritty"
    "tmux"
    "docker"
    "arc"
    "geojson"
    "coords"
    "deploy"

    "browser"
    "telegram"
    "matrix-client"
    "recording"
    "rutranslit"
  ];
in {
  config = lib.mkMerge [
    (config.flake.lib.mkSystems.linuxHomeManager {
      username = "tabuchkin";
      hostname = "tabuchkin-nix";
      inherit modules;
    })
    (config.flake.lib.mkSystems.linuxSystemManager {
      username = "tabuchkin";
      hostname = "tabuchkin-nix";
      inherit modules;
    })
    {
      desktop.secondary-monitors = [
        {
          name = "Lenovo Group Limited T27UD-40 VNACDWHA";
          mode = {
            width = 3840;
            height = 2160;
            refresh = 60.0;
          };
          extraNiriSettings = {
            scale = 2;
          };
        }
      ];
      ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU27SYcgWNwp0HaUIQzYCWOZx/tD9pp5vGizldB6LoE tabuchkin@tabuchkin-nix"
      ];
    }
  ];
}

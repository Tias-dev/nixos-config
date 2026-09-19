{config, ...}: let
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

    "browser"
    "recording"
    "torrent"
    "documents"
    "matrix-client"
    "rutranslit"
  ];
in {
  flake = {
    nixosConfigurations.laptop-raison = config.flake.lib.mkSystems.linux "laptop-raison" "raison";
    modules.nixos."hosts/laptop-raison" = {
      imports =
        config.flake.lib.collectModules config modules "raison";
      networking = {
        wireless.enable = true;
        supplicant."wlp63s0".extraCmdArgs = "-C /var/run/wpa_supplicant";
      };
    };
    modules.homeManager."hosts/laptop-raison" = {
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
    desktop.secondary-monitors = [
      {
        name = "HDMI-A-2";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
      }
    ];
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJC7ayh2luEr8pPQ/TZGAu52lPQimTyTJLnn2X08W0m raison@laptop-raison"
    ];
  };
}

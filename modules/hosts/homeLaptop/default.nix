{config, ...}: let
  modules = [
    "efiBoot"
    "sops"
    "xray-client"
    "desktop"
    "niri"
    "bluetooth"
    "mai-wifi-auto-login"

    "develop"
    "neovim"
    "zsh"
    "kitty"
    "alacritty"
    "tmux"
    "docker"

    "browser"
    "recording"
    "torrent"
    "documents"
  ];
in {
  flake = {
    nixosConfigurations.laptop-raison = config.flake.lib.mkSystems.linux "laptop-raison" "raison";
    modules.nixos."hosts/laptop-raison" = {
      imports =
        config.flake.lib.collectModules config modules "raison";
    };
    modules.homeManager."hosts/laptop-raison" = {
      desktop.primary-monitor = {
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
    };
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJC7ayh2luEr8pPQ/TZGAu52lPQimTyTJLnn2X08W0m raison@laptop-raison"
    ];
  };
}

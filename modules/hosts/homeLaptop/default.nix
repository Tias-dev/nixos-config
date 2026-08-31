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
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJC7ayh2luEr8pPQ/TZGAu52lPQimTyTJLnn2X08W0m raison@laptop-raison"
    ];
  };
}

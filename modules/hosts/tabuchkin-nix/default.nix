{config, ...}: let
  modules = [
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "zsh"
    "neovim"
    "kitty"
    "alacritty"
    "tmux"
    "docker"
    "arc"

    "browser"

    "geojson"
    "telegram"
  ];
in {
  flake = {
    homeConfigurations.tabuchkin-nix = config.flake.lib.mkSystems.linuxHMOnly "tabuchkin-nix" {username = "tabuchkin";};
    modules.homeManager."hosts/tabuchkin-nix" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };

    systemConfigs.default = config.flake.lib.mkSystems.linuxSMOnly "tabuchkin-nix";
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU27SYcgWNwp0HaUIQzYCWOZx/tD9pp5vGizldB6LoE tabuchkin@tabuchkin-nix"
    ];
  };
}

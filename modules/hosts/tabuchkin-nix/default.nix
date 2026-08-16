{config, ...}: let
  modules = [
    "desktop"
    "niri"
    "swaylock"
    "bluetooth"

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

    "browser"

    "geojson"
    "telegram"
    "recording"
  ];
in {
  flake = {
    homeConfigurations.tabuchkin-nix = config.flake.lib.mkSystems.linuxHMOnly "tabuchkin-nix" {username = "tabuchkin";};
    modules.homeManager."hosts/tabuchkin-nix" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };

    systemConfigs."tabuchkin-nix" = config.flake.lib.mkSystems.linuxSMOnly "tabuchkin-nix";
    modules.systemManager."hosts/tabuchkin-nix" = {
      imports = config.flake.lib.collectSMModules config modules;
      environment.systemPackages = config.flake.homeConfigurations.tabuchkin-nix.config.home.packages;
    };
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU27SYcgWNwp0HaUIQzYCWOZx/tD9pp5vGizldB6LoE tabuchkin@tabuchkin-nix"
    ];
  };
}

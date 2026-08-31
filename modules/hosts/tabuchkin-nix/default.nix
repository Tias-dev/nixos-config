{config, ...}: let
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

    "browser"

    "geojson"
    "coords"
    "telegram"
    "recording"

    "rutranslit"
  ];
in {
  config.flake = {
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
    homeConfigurations.tabuchkin-nix = config.flake.lib.mkSystems.linuxHMOnly "tabuchkin-nix" {username = "tabuchkin";};
    modules.homeManager."hosts/tabuchkin-nix" = {
      imports = config.flake.lib.collectHomeModules config modules;
      desktop.primary-monitor = {
        name = "InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x05AB Unknown";
        mode = {
          width = 2560;
          height = 1600;
          refresh = 90.0;
        };
      };
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

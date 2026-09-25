{config, ...}: let
  modules = [
    "desktop"
    "niri"
    "bluetooth"
    "swaylock"

    "develop"
    "zsh"
    "neovim"
    "kitty"
    "tmux"
    "browser"
  ];
in {
  flake = {
    homeConfigurations."raison-cachy" = config.flake.lib.mkSystems.linuxHMOnly "raison-cachy" {username = "raison";};
    modules.homeManager."hosts/raison-cachy" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4GHahSCM5IoArGolMGdpSmdDG2AzhU70hhZnqyuzmi raison@raison-cachy"
    ];
  };
}

{
  config,
  lib,
  ...
}: let
  modules = [
    "desktop"
    "niri"
    "swaylock"

    "develop"
    "zsh"
    "neovim"
    "kitty"
    "tmux"
    "browser"
  ];
in {
  config = lib.mkMerge [
    (config.flake.lib.mkSystems.linuxHomeManager {
      username = "raison";
      hostname = "raison-cachy";
      inherit modules;
    })
    {
      ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4GHahSCM5IoArGolMGdpSmdDG2AzhU70hhZnqyuzmi raison@raison-cachy"
      ];
    }
  ];
}

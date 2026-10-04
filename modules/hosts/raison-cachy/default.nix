{
  config,
  configurations-lib,
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
    (( configurations-lib.mkSystems config).linuxHomeManager {
      username = "raison";
      hostname = "raison-cachy";
      inherit modules;
    })
    {
      flake.ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4GHahSCM5IoArGolMGdpSmdDG2AzhU70hhZnqyuzmi raison@raison-cachy"
      ];
    }
  ];
}

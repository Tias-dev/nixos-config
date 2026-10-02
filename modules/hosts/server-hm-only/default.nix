{config, lib, ...}: let
  modules = [
    "develop"
    "neovim"
    "zsh"
    "tmux"
    "arc"
  ];
in {
  config = lib.mkMerge [
    (config.flake.lib.mkSystems.linuxHomeManager {
      username = "tabuchkin";
      hostname = "sdg-robot-bl-vla.vla.yp-c.yandex.net";
      inherit modules;
    })
    {
      ssh-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4GHahSCM5IoArGolMGdpSmdDG2AzhU70hhZnqyuzmi raison@raison-cachy"
      ];
    }
  ];
  flake = {
    modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {
    };
  };
}

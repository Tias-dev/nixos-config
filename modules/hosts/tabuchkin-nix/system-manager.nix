{config, ...}:
config.flake.lib.personalSystemManagerModule {
  hostname = "tabuchkin-nix";
  module = ({config, ...}: {
    environment.systemPackages = config.flake.homeConfigurations.tabuchkin-nix.config.home.packages;
  });
}

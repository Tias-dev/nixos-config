{
  config,
  configurations-lib,
  ...
}: let
  hm-packages = config.flake.homeConfigurations.tabuchkin-nix.config.home.packages;
in {
  config = configurations-lib.personalSystemManagerModule {
    hostname = "tabuchkin-nix";
    module = {
      environment.systemPackages = hm-packages;
    };
  };
}

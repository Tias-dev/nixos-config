{
  configurations-lib,
  config,
  ...
}: {
  config = configurations-lib.personalNixosModule {
    hostname = "laptop-tias";
    module = config.flake.lib.mkTailscaleService {};
  };
}

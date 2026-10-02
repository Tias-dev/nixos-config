{config, ...}:
config.flake.lib.personalNixosModule {
  hostname = "laptop-raison";
  module = {
    config = {
      extra-docker = {
        custom-data-root = "/mnt/storage";
        use-containerd = true;
      };
    };
  };
}

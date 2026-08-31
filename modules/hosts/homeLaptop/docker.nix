{
  config.flake.modules.nixos."hosts/laptop-raison" = {
    config = {
      extra-docker = {
        custom-data-root = "/mnt/storage";
        use-containerd = true;
      };
    };
  };
}

{
  config.flake.modules.nixos.docker = {
    lib,
    config,
    ...
  }: {
    options = {
      extra-docker = lib.mkOption {
        type = lib.types.submodule {
          options = {
            custom-data-root = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
            };
            use-containerd = lib.mkEnableOption "containerd for docker";
          };
        };
      };
    };
    config = {
      virtualisation = {
        docker = {
          enable = true;
          daemon.settings = lib.mkIf (config.extra-docker.custom-data-root != null) {
            data-root = "${config.extra-docker.custom-data-root}/docker";
          };
          extraOptions = lib.mkIf config.extra-docker.use-containerd ''
            --containerd=/run/containerd/containerd.sock
          '';
        };
        containerd = lib.mkIf config.extra-docker.use-containerd {
          enable = true;
          settings = lib.mkIf (config.extra-docker.custom-data-root != null) {
            root = "${config.extra-docker.custom-data-root}/lib/containerd";
          };
        };
      };
    };
  };
}

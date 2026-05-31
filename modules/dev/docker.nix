{
  flake.modules.nixos.docker = {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          data-root = "/mnt/storage/docker";
        };
        extraOptions = ''
          --containerd=/run/containerd/containerd.sock
        '';
      };
      containerd = {
        enable = true;
        settings = {
          root = "/mnt/storage/lib/containerd";
        };
      };
    };
  };
}

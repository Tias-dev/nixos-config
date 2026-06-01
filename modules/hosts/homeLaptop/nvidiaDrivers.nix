{
  flake.modules.nixos."hosts/laptop-raison" = {
    # nvidia prime graphics
    hardware.nvidia-container-toolkit.enable = true;
    hardware.graphics.enable = true;

    nixpkgs.config.allowUnfree = true;
    hardware.nvidia.open = false; # My nvidia GPU not supported by open source driver so i set proprietary one

    # There is my graphics config for integrated Intel Gpu and dedicated Nvidia rtx 4050 gpu
    # You may change this config to you hardware preset
    services.xserver.videoDrivers = [
      "modesetting" # intel iGPU
      "nvidia"
    ];

    # see https://wiki.nixos.org/wiki/NVIDIA#Hybrid_graphics_with_PRIME
    hardware.nvidia = {
      modesetting.enable = true; # for wayland support
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
}

{config, ...}:
config.flake.lib.personalHomeManagerModule {
  hostname = "tabuchkin-nix";
  module = {
    desktop.primary-monitor = {
      name = "InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x05AB Unknown";
      mode = {
        width = 2560;
        height = 1600;
        refresh = 90.0;
      };
    };
  };
}

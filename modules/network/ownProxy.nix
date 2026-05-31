{
  flake.modules.nixos.ownProxy = {config, ... }: {
    services.xray = {
      enable = true;
      settingsFile = config.sops.secrets.xrayConfig.path;
    };
    systemd.services.xray.environment = { XRAY_LOCATION_ASSSET = "/home/raison/.config/xray_assets/"; };
    networking = {
      proxy.default = "socks5://localhost:10800";
      proxy.noProxy = "127.0.0.1,localhost";
    };
  };
}

{
  flake.modules.nixos.ownProxy = {config, ...}: 
  let
    username = config.flake.modules.homeManager.home.username;
  in {
    services.xray = {
      enable = true;
      settingsFile = config.sops.secrets.xrayConfig.path;
    };
    systemd.services.xray.environment = {XRAY_LOCATION_ASSSET = "/home/${username}/.config/xray_assets/";};
    networking = {
      proxy.default = "socks5://localhost:10800";
      proxy.noProxy = "127.0.0.1,localhost";
    };
  };
}

{config, ...}: let
  inherit (config.flake.meta) xray-assets-path;
  inherit (config.flake.modules.nixos) xray-update-blocklists;
in {
  flake.modules.nixos.xray-client = {
    config,
    lib,
    ...
  }: let
    proxy-addr = "socks5://localhost:10800";
  in {
    services.xray = {
      enable = true;
      settingsFile = config.sops.secrets.xray-client.path;
    };
    systemd.services.xray.environment = {XRAY_LOCATION_ASSSET = xray-assets-path;};
    networking = {
      proxy.default = proxy-addr;
      proxy.noProxy = "127.0.0.1,localhost";
    };
    sops = {
      secrets.xray-client = {
        format = "json";
        sopsFile = ../../secrets/xray/xray-client.json;
        key = "";
        restartUnits = ["xray.service"];
      };
    };

    # auto-import xray blocklists updater
    imports = [
      xray-update-blocklists
    ];
    xray-update-blocklists = {
      enable = lib.mkDefault true;
      proxy.enable = lib.mkDefault true;
    };
  };
}

{config, ...}: let
  inherit (config.meta) xray-assets-path;
  inherit (config.flake.modules.nixos) xray-update-blocklists;
in {
  config.flake.modules.nixos.xray-server = {
    config,
    lib,
    ...
  }: {
    config = {
      services.xray = {
        enable = true;
        settingsFile = config.sops.secrets.xray-server.path;
      };
      sops.secrets = {
        xray-server = {
            sopsFile = ../../secrets/xray/xray-server.json;
        };
      };
      systemd.services.xray.environment = {XRAY_LOCATION_ASSSET = xray-assets-path;};
      # auto-import xray blocklists updater
      imports = [
        xray-update-blocklists
      ];
      xray-update-blocklists = {
        enable = lib.mkDefault true;
        proxy.enable = lib.mkDefault true;
      };
    };
  };
}

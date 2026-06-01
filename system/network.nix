{
  config,
  hostname,
  username,
  ...
}: {
  networking = {
    hostName = "${hostname}"; # Define your hostname.
    proxy.default = "socks5://localhost:10800";
    proxy.noProxy = "127.0.0.1,localhost";

    # Configure network connections interactively with nmcli or nmtui.
    networkmanager.enable = true;
    nameservers = [
      "77.88.8.8"
      "77.88.8.1"
      "8.8.8.8"
    ];
    nftables.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false; # improve boot time by disabling waiting for network

  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.xrayConfig = {
      format = "json";
      sopsFile = ../secrets/xray.json;
      key = "";
    };
  };

  services.xray = {
    enable = true;
    settingsFile = config.sops.secrets.xrayConfig.path;
  };
  systemd.services.xray.environment = {XRAY_LOCATION_ASSSET = "/home/${username}/.config/xray_assets/";};
}

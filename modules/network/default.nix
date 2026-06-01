{
  flake.modules.nixos.nixos = {
    networking = {
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
  };
}

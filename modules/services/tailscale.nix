{
  config.flake.lib.mkTailscaleService = {port ? 51016}: {
    services.tailscale = {
      enable = true;
      inherit port;
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [port];
    };
  };
}

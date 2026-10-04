{
  config.flake.lib = {
    mkStaticNetworkAddressModule = {
      address,
      gateway,
      interface,
      prefixLength ? 24,
    }: {
      networking.interfaces.${interface}.ipv4.addresses = [
        {
          inherit address prefixLength;
        }
      ];
      networking.defaultGateway = gateway;
    };
  };
}

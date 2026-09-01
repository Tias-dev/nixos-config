{
  config.flake.modules.nixos.nginx = {config, ...}: {
    assertions = [
      {
        assertion = config.networking.domain != null;
        message = "config.networking.domain must be set(e.g. example.org) to use this multidomain nginx config";
      }
    ];
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts."${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}

{config, ...}: let
  config' = config;
  hostname = "tias-dev-tech";
  domain = "tias-dev.tech";
  email = "www.tias.dev@gmail.com";
  inherit
    (config.flake.lib)
    mkStaticNetworkAddressModule
    mkForgejoModule
    collectModules
    mkMonitoringModule
    mkGrafanaNtfyForwarder
    mkMatrixServer
    mkNtfyService
    mkPostgRESTModule
    ;

  nixosModules = [
    "user"
    "sops"
    "docker"
    "nginx"
    "postgresql"

    "neovim"
    "zsh"
    "tmux"
  ];
in {
  flake = {
    nixosConfigurations.${domain} = config.flake.lib.mkRemoteServer {
      inherit hostname domain;
      username = "tias-dev";
    };
    modules.nixos."hosts/${domain}" = {
      config,
      username,
      ...
    }: {
      disko.devices.disk.disk1.device = "/dev/sda";
      home-manager.backupFileExtension = ".bak";
      imports =
        [
          (mkStaticNetworkAddressModule {
            address = "178.208.81.239";
            gateway = "178.208.81.2";
            interface = "enp1s0";
          })
          (mkForgejoModule {
            domain = "git.tias-dev.tech";
            disableRegistration = true;
            addDefaultRunner = true;
            email = email;
          })
          (mkMatrixServer {
            subdomain = "matrix";
          })
          (mkMonitoringModule {
            domain = "monitoring.tias-dev.tech";
            adminEmail = email;
          })
          (mkGrafanaNtfyForwarder {
            ntfyFqdn = "ntfy.${config.networking.domain}";
            ntfyTopic = "notify-grafana";
          })
          (mkNtfyService {})
          (mkPostgRESTModule {
            port = 3007;
            extraSqlInitScriptPath = ./postgresql-init-script.sql;
          })
        ]
        ++ (collectModules config' nixosModules username);
      security.acme.acceptTerms = true;
      security.acme.defaults.email = email;
      networking.firewall.allowedTCPPorts = [80 443];
    };
  };
}

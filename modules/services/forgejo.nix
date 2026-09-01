{config, ...}: let
  inherit (config.flake) ssh-keys;
in {
  config.flake.lib.mkForgejoModule = {
    domain,
    disableRegistration ? true,
    addDefaultRunner ? true,
    email ? "root@localhost",
  }: {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.services.forgejo;
    srv = cfg.settings.server;
  in {
    services.nginx = {
      virtualHosts.${cfg.settings.server.DOMAIN} = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/" = {
          proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
          recommendedProxySettings = true;
        };
      };
    };
    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe cfg.package} admin user";
      user = "Tias"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in ''
      ${adminCmd} create --admin --email ${email} --username ${user} --password "$(cat ${config.sops.secrets.forgejo-admin-password.path})" || true
    '';
    environment.systemPackages = [cfg.package];
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      # Enable support for Git Large File Storage
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = domain;
          # You need to specify this to remove the port from URLs in the web UI.
          ROOT_URL = "https://${srv.DOMAIN}/";
          HTTP_PORT = 3000;
        };
        # You can temporarily allow registration to create an admin user.
        service.DISABLE_REGISTRATION = disableRegistration;
        # Add support for actions, based on act: https://github.com/nektos/act
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        mailer = {
          ENABLED = true;
          NAME = "Forgejo (tias-dev)";
          SMTP_ADDR = "smtp.gmail.com";
          FROM = "noreply@${srv.DOMAIN}";
          USER = "${email}";
        };
      };
      secrets = {
        mailer.PASSWD = config.sops.secrets.forgejo-mail-password.path;
      };
    };
    sops.secrets = {
      forgejo-admin-password = {
        sopsFile = ../../secrets/forgejo/secrets.yaml;
        format = "yaml";
        key = "admin-password";
        owner = "forgejo";
      };
      forgejo-mail-password = {
        sopsFile = ../../secrets/forgejo/secrets.yaml;
        format = "yaml";
        key = "mail-password";
        owner = "forgejo";
      };
      forgejo-runner-token = {
        sopsFile = ../../secrets/forgejo/secrets.yaml;
        format = "yaml";
        key = "runner-token";
        owner = "forgejo";
      };
    };
    services.gitea-actions-runner = lib.mkIf addDefaultRunner {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = "monolith";
        url = "https://${domain}";
        tokenFile = config.sops.secrets.forgejo-runner-token.path;
        labels = [
          "ubuntu-latest:docker://node:18-bullseye"
          "native:host"
        ];
      };
    };
  };

  config.flake.modules.homeManager.forgejo-client = {pkgs, ...}: {
    home.packages = with pkgs; [forgejo-cli];
    sops.secrets.admin-fj-token = {
      sopsFile = ../../secrets/forgejo/secrets.yaml;
      format = "yaml";
      key = "admin-fj-token";
    };
  };
}

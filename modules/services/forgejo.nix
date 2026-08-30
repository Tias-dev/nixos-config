{
  config.flake.lib.mkForgejoModule = {
    domain,
    enableRegistration ? true,
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
        locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
      };
    };
    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe cfg.package} admin user";
      user = "joe"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "qwerty12Z" || true
    '';

    environment.systemPackages = [config.services.forgejo.package]; # to be able use forgejo-cli locally
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
        service.DISABLE_REGISTRATION = !enableRegistration;
        # Add support for actions, based on act: https://github.com/nektos/act
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        # # Sending emails is completely optional
        # # You can send a test email from the web UI at:
        # # Profile Picture > Site Administration > Configuration >  Mailer Configuration
        # mailer = {
        #   ENABLED = true;
        #   SMTP_ADDR = "mail.example.com";
        #   FROM = "noreply@${srv.DOMAIN}";
        #   USER = "noreply@${srv.DOMAIN}";
        # };
      };
      # secrets = {
      #   mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
      # };
    };

    # age.secrets.forgejo-mailer-password = {
    #   file = ../secrets/forgejo-mailer-password.age;
    #   mode = "400";
    #   owner = "forgejo";
    # };
  };
}

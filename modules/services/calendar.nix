{
  config.flake.lib = {
    mkRadicaleService = {
      port ? 5232,
      subdomain ? "calendar",
    }: {config, ...}: {
      assertions = [
        {
          assertion = config.services.nginx.enable;
          message = "Expected to run radicale under nginx, but nginx is not enabled!";
        }
        {
          assertion = config.networking.domain != null;
          message = "Expected config.networking.domain to be set";
        }
      ];

      services.radicale = {
        enable = true;
        settings = {
          server = {
            hosts = ["127.0.0.1:${toString port}" "[::1]:${toString port}"];
          };
          auth = {
            type = "htpasswd";
            htpasswd_filename = config.sops.secrets.users-htpass.path;
            htpasswd_encryption = "bcrypt";
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections";
          };
        };
        rights = {
          root = {
            user = ".+";
            collection = "";
            permissions = "R";
          };
          principal = {
            user = ".+";
            collection = "{user}";
            permissions = "RW";
          };
          calendars = {
            user = ".+";
            collection = "{user}/[^/]+";
            permissions = "rw";
          };
        };
      };

      services.nginx.virtualHosts = {
        "${subdomain}.${config.networking.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString port}";
          };
        };
      };

      sops.secrets.users-htpass = {
        sopsFile = ../../secrets/radicale/users.htpass;
        owner = config.services.radicale.user;
        key = "data";
      };
    };
  };
}

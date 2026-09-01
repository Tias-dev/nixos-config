{
  config.flake.lib = {
    mkMatrixServer = {domain}: let
      baseUrl = "https://${domain}";
      clientConfig."m.homeserver".base_url = baseUrl;
      serverConfig."m.server" = "${domain}:443";
      mkWellKnown = data: ''
        default_type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '${builtins.toJSON data}';
      '';
    in {config, ...}: {
      services.postgresql.enable = true;
      systemd.services.init-matrix-db = {
        description = "Init matrix db and role after postgresql starts";
        after = ["postgresql.service"];
        wants = ["postgresql.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          RemainAfterExit = true;
        };

        script =
          /*
          bash
          */
          ''
            ${config.services.postgresql.package}/bin/psql -f ${./matrix-postgres-init.sql}
          '';
      };
    };
  };
}

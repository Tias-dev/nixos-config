{lib, ...}: {
  config.flake.lib = {
    mkPostgRESTModule = {
      port ? 3000,
      host ? "localhost",
      schema ? "api",
      role ? "postgrest_default",
      auth_role ? "authenticator",
      extraSqlInitScriptPath ? null,
    }: {
      config,
      pkgs,
      ...
    }: {
      assertions = [
        {
          assertion = config.services.postgresql.enable == true;
          message = "Expected postgresql to be enabled";
        }
      ];
      services.postgrest = {
        enable = true;
        jwtSecretFile = config.sops.secrets.postgrest-jwt-file.path;
        pgpassFile = config.sops.secrets.postgrest-postgresql-pgpass.path;

        settings = {
          db-uri = {
            user = auth_role;
            dbname = "postgres";
          };
          db-schemas = schema;
          server-host = host;
          server-port = port;
          server-unix-socket = null;
        };
      };

      services.postgresql = {
        authentication = ''
          local all ${auth_role} peer map=ident-${auth_role}
        '';
        identMap = ''
          ident-${auth_role} postgrest ${auth_role}
        '';
      };

      # Run initial setup for postgres
      systemd.services.init-postgrest-db = {
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
          (
            /*
            bash
            */
            ''
              password=$(cat ${config.sops.secrets.postgrest-postgresql-pgpass.path} | ${pkgs.gawk}/bin/awk -F':' '{print $NF}')
              config=$(cat ${./postgrest-init-script.sql} | sed \
                -e 's/@schema@/${schema}/g' \
                -e 's/@role@/${role}/g' \
                -e 's/@auth_role@/${auth_role}/g' \
                -e 's/@schema@/${schema}/g' \
                -e "s/@password@/$password/g"
              )

              if echo "$config" | grep -q '@'; then
                echo "Detected not substituted fields!"
                echo "Script with current substitutions:"
                echo "$config"
                exit 1
              fi
              ${config.services.postgresql.package}/bin/psql -c "$config"
            ''
          )
          + (lib.optionalString (extraSqlInitScriptPath != null)
            /*
            bash
            */
            ''
              config=$(cat ${extraSqlInitScriptPath} | sed \
                -e 's/@schema@/${schema}/g' \
                -e 's/@role@/${role}/g' \
                -e 's/@auth_role@/${auth_role}/g' \
                -e 's/@schema@/${schema}/g'
              )
              if echo "${extraSqlInitScriptPath}" | grep -q '@'; then
                echo "Detected not substituted fields!"
                echo "Script with current substitutions:"
                echo "$config"
                exit 1
              fi
              ${config.services.postgresql.package}/bin/psql -c "$config"
            '');
      };

      sops.secrets.postgrest-jwt-file = {
        sopsFile = ../../../secrets/postgrest/secrets.yaml;
        format = "yaml";
        key = "postgrest_jwt_key";
      };

      sops.secrets.postgrest-postgresql-pgpass = {
        sopsFile = ../../../secrets/postgrest/secrets.yaml;
        format = "yaml";
        key = "postgrest_postgresql_pgpass";
        owner = "postgres";
      };
    };
  };
}

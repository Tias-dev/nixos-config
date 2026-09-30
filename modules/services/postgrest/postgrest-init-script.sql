CREATE SCHEMA IF NOT EXISTS @schema@;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '@role@') THEN
        CREATE ROLE @role@ nologin;
   END IF;
END$$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '@auth_role@') THEN
        CREATE ROLE @auth_role@ noinherit login PASSWORD '@password@';
   END IF;
END$$;

GRANT @role@ TO @auth_role@;

GRANT usage ON SCHEMA @schema@ to @role@;

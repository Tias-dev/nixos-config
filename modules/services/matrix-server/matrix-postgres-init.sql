CREATE ROLE "matrix-synapse" LOGIN;
CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
  TEMPLATE template0
  LC_COLLATE = "C"
  LC_CTYPE = "C";

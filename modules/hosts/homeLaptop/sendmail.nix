{
  config,
  configurations-lib,
  ...
}: let
  inherit (config.flake.lib) mkSendMailProgram;
in {
  config = configurations-lib.personalNixosModule {
    hostname = "laptop-raison";
    module = {config, ...}: {
      imports = [
        (mkSendMailProgram {
          userEmail = "www.tias.dev@gmail.com";
          passwordPath = config.sops.secrets.tias-dev-email-pass.path;
        })
      ];
      sops.secrets.tias-dev-email-pass = {
        sopsFile = ../../../secrets/forgejo/secrets.yaml;
        key = "mail-password";
        format = "yaml";
        owner = "raison";
      };
    };
  };
}

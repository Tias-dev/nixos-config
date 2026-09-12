{config, ...}: let
  inherit (config.flake.lib) mkSendMailProgram;
in {
  config.flake.modules.nixos."hosts/laptop-raison" = {config, ...}: {
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
}

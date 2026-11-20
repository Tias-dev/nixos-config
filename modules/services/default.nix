{
  config.flake.modules.nixos.nixos = {
    lib,
    config,
    ...
  }: {
    options.nginx-vhosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    config = {
      assertions = let
          defined-vhosts = (lib.sort builtins.lessThan (lib.unique config.nginx-vhosts));
          all-vhosts = (lib.sort builtins.lessThan
              (lib.filter
                (vhost:
                  (!(lib.hasPrefix "://" vhost))
                  && (vhost != "localhost"))
                (lib.attrNames config.services.nginx.virtualHosts)));
          in [
        {
          assertion = defined-vhosts == all-vhosts;
          message = ''
            For every nginx virtualHost 'somevhost' the vhost name must be added to config.nginx-vhosts
            aka config.nginx-vhosts = ['somevhost']
            Missed vhosts:
            ${lib.concatStringsSep "\n" (lib.lists.subtractLists defined-vhosts all-vhosts)}
          '';
        }
      ];
    };
  };
}

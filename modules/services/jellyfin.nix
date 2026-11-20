{
  config.flake.lib = {
    mkJellyfinService = {domain ? null}: {lib, username, ...}: {
      services.jellyfin = {
        enable = true;
      };

      users.users.${username}.extraGroups = ["jellyfin"];
      systemd.tmpfiles.rules = [
        "d /srv/jellyfin 0770 jellyfin jellyfin -"
      ];

      nginx-vhosts = lib.mkIf (domain != null) [ domain ];
      services.nginx.virtualHosts = lib.mkIf (domain != null) {
        "${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:8096"; # 8096 seems like default port for jellyfin but there is no special nixos option for it
          };
        };
      };
    };
  };
}

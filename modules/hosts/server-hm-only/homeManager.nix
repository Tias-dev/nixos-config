{
  config.flake.modules.homeManager."hosts/server-hm-only" = {pkgs, ...}: {
    programs.home-manager.enable = true;
  };
}

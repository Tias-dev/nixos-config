{
  flake.modules.homeManager.torrent = {pkgs, ...}: {
    home.packages = [pkgs.transmission_4-qt];
  };
}

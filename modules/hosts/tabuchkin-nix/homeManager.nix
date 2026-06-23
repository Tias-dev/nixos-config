{
  config.flake.modules.homeManager."hosts/tabuchkin-nix" = {pkgs, ...}: {
    home.packages = with pkgs; [wl-clipboard alacritty];
    programs.home-manager.enable = true;
  };
}

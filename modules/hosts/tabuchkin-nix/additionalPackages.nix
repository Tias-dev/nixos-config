{
  config.flake.modules.homeManager."hosts/tabuchkin-nix" = {pkgs, ...}: {
    home.packages = with pkgs; [wl-clipboard alacritty];
  };
}

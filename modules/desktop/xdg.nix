{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    xdg.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        gnome-keyring
      ];
      configPackages = [pkgs.niri];
      config = {
        default = {
          "org.freedesktop.impl.portal.ScreenCast" = [
            "gnome"
          ];
        };
      };
    };
  };
}

{
  config.flake.modules.homeManager.niri = {config, pkgs, ...}: {
    config = {
      xdg.portal = {
        configPackages = [config.program.niri.package];
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          gnome-keyring
        ];
        config = {
          default = {
            "org.freedesktop.impl.portal.ScreenCast" = [
              "gnome"
            ];
            "org.freedesktop.portal.RemoteDesktop" = ["gnome"];
          };
        };
      };
    };
  };
}

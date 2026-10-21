{
  flake.modules.homeManager.desktop = {pkgs, lib, config, ...}: {
    xdg.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        gnome-keyring
      ]
        ++ (lib.optionals (config.primary-wm == "niri") [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ]);
      configPackages = [pkgs.niri];
      config = {
        default = {
          "org.freedesktop.impl.portal.ScreenCast" = lib.mkIf ( config.primary-wm != "umbriel" ) [
             "gnome"
          ];
          "org.freedesktop.portal.RemoteDesktop" = [ "gnome" ];
        };
      };
    };
  };
}

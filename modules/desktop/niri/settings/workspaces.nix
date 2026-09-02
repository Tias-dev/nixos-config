{
  config.flake.modules.homeManager.niri = {
    config,
    lib,
    ...
  }: let
    primary-monitor-workspaces = {
      "p1-browser" = {name = "browser";};
      "p2-terminal" = {name = "terminal";};
    };
  in {
    niri-settings.workspaces =
      (lib.mapAttrs (name: attrs: attrs // {open-on-output = config.desktop.primary-monitor.name;}) primary-monitor-workspaces)
      // {
        # "01-browser" = {
        #   open-on-output = "HDMI-A-2";
        #   name = "browser";
        # };
        "s3-doc-viewer" = {
          open-on-output = "HDMI-A-2";
          name = "doc-viewer";
        };
      };
  };
}

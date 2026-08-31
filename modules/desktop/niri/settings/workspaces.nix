{
  config.flake.modules.homeManager.niri = {
    config,
    lib,
    ...
  }: let
    primary-monitor-rules = {
      "02-terminal" = {name = "terminal";};
    };
  in {
    niri-settings.workspaces =
      (lib.mapAttrs (name: attrs: attrs // {open-on-output = config.desktop.primary-monitor.name;}) primary-monitor-rules)
      // {
        "01-browser" = {
          open-on-output = "HDMI-A-2";
          name = "browser";
        };
        "03-doc-viewer" = {
          open-on-output = "HDMI-A-2";
          name = "doc-viewer";
        };
      };
  };
}

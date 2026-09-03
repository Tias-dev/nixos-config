{config, ...}: let
  inherit (config.flake.desktop) secondary-monitors;
in {
  config.flake.modules.homeManager.niri = {
    config,
    lib,
    ...
  }: let
    inherit (config.desktop) secondary-monitor-name;

    # open on second monitor if plugged, fallback to primary monitor
    common-workspaces = {
      "01-browser" = {name = "browser";};
      "02-terminal" = {name = "terminal";};
      "03-chat" = {name = "chat";};
      "04-doc-viewer" = {name = "doc-viewer";};
    };
    # only primary monitor
    primary-workspaces = {
    };
    workspaces-override = monitor-name: (
      if (monitor-name != null)
      then (lib.mapAttrs (name: attrs: attrs // {open-on-output = monitor-name;}))
      else (_: {})
    );
  in {
    niri-settings = {
      workspaces = (workspaces-override config.desktop.primary-monitor.name primary-workspaces) // (workspaces-override config.desktop.primary-monitor.name common-workspaces);
    };
  };
}

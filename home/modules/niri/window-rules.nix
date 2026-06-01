[
  {
    geometry-corner-radius = {
      bottom-left = 12.0;
      bottom-right = 12.0;
      top-left = 12.0;
      top-right = 12.0;
    };
    clip-to-geometry = true;
    open-maximized = true;
    open-focused = true;
  }
  {
    matches = [
      {app-id = "firefox";}
    ];
    open-on-workspace = "browser";
  }
  {
    matches = [
      {app-id = "Alacritty";}
      {app-id = "kitty";}
    ];
    open-on-workspace = "terminal";
  }
  {
    matches = [
      {app-id = "zathura";}
      {app-id = "okular";}
    ];
    open-on-workspace = "doc-viewer";
  }
  {
    matches = [
      {app-id = "keepassxc";}
    ];
    block-out-from = "screen-capture";
  }
  {
    matches = [
      {
        app-id = "zathura";
      }
    ];
    open-maximized = false;
  }

  {
    matches = [
      {is-window-cast-target = true;}
    ];
    focus-ring = {
      active = {
        color = "#f38ba8";
      };
      inactive = {
        color = "#7d0d2d";
      };
    };

    border = {
      inactive = {
        color = "#7d0d2d";
      };
    };
    shadow = {
      color = "#7d0d2d70";
    };

    tab-indicator = {
      active = {
        color = "#f38ba8";
      };
      inactive = {
        color = "#7d0d2d";
      };
    };
  }
]

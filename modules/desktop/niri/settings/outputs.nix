{
  flake.modules.generic.niri.settings.outputs = {
    "eDP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 144.0;
      };
      scale = 1.2;

      focus-at-startup = true;
      position = {
        x = 1280;
        y = 0;
      };
    };

    "HDMI-A-2" = {
      mode = {
        width = 1680;
        height = 1050;
        refresh = 60.0;
      };
      scale = 1;

      focus-at-startup = false;
      position = {
        x = 0;
        y = 0;
      };
    };
  };
}

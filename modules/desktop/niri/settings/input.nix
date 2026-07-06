{
  flake.modules.generic.niri.settings.input = {
    keyboard = {
      xkb = {
        layout = "us,ru";
        options = "caps:swapescape";
      };
      numlock = true;
    };

    touchpad = {
      # off = true;
      tap = true;
      natural-scroll = true;
    };
  };
}

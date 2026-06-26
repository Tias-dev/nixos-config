{
  flake.modules.generic.niri.settings.input = {
    keyboard = {
      xkb = {
        layout = "us,ru";
        options = "caps:super";
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

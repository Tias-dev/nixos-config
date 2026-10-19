{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.meta) terminal;
in {
  config.flake.modules = {
    nixos.umbriel = {
      imports = [inputs.umbriel.nixosModules.default];
      active-display-manager = "umbriel";
      programs.umbriel.enable = true;
      nix.settings = {
        extra-substituters = ["https://umbriel.cachix.org"];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
        ];
      };
    };

    homeManager.umbriel = {
      config,
      lib,
      ...
    }: let
      lock-cmd = config.desktop.custom-lock-cmd;
    in {
      imports = [inputs.umbriel.homeModules.default];
      programs.umbriel = {
        enable = true;
        settings = {
          appearance = {
            prefer_no_csd = true;
            border_width = 2;
            # border_radius = 10;
            blur = {
              enabled = true;
              optimized = true;
              passes = 3;
              radius = 3;
              noise = 0.02;
              brightness = 0.9;
              contrast = 0.9;
              saturation = 1.1;
            };
          };
          window_rule = [
            {
              blur = true;
              blur_optimized = true;
            }
            {
              default_floating = true;
              # "match.app_id" = "^dev.noctalia.Noctalia$";
              # default_size = [1020 900];
            }
          ];
          layer_rule = [
            {
              # "match.namespace" = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
              blur = true;
              blur_ignore_alpha = 0.5;
              blur_optimized = false;
            }
          ];

          input = {
            keyboard = {
              layout = "us,ru";
              options = "caps:swapescape";
              numlock_toggle = true;
            };
            touchpad = {
              left_handed = false;
              tap = true;
              natural_scroll = true;
            };
          };
          keybinds = {
            "Mod+T" = "spawn:${terminal.path}";
            "Mod+B" = "spawn:${lib.getExe config.browser.package}";
            "Mod+Shift+Slash" = "cheatsheet-toggle";
            "Mod+Shift+L" =
              if lock-cmd == null
              then "spawn:noctalia msg session lock"
              else "spawn:${lock-cmd}";
            "Mod+Shift+P" = "spawn:noctalia msg panel-toggle session";
            # alt + tab to switch between monitors?
            "Mod+D" = "spawn:noctalia msg panel-toggle launcher";
            "Mod+Q" = "window-close";

            "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
            "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
            "XF86AudioMute" = "spawn:noctalia msg volume-mute";
            "XF86AudioMicMute" = "spawn:noctalia msg mic-mute";
            "XF86AudioPlay" = "spawn:noctalia msg audio toggle";
            "XF86AudioStop" = "spawn:noctalia msg audio stop";
            "XF86AudioPrev" = "spawn:noctalia msg audio previous";
            "XF86AudioNext" = "spawn:noctalia msg audio next";
            "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";
            "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";

            "Mod+O" = "overview-toggle";

            "Mod+S" = "spawn:noctalia msg panel-toggle control-center";
            "Mod+Comma" = "spawn:noctalia msg settings-toggle";
            "Alt+Tab" = "spawn:noctalia msg window-switcher hold";
            "Mod+Shift+A" = "spawn:noctalia msg screenshot-annotate";
            "Mod+Ctrl+A" = "spawn:noctalia msg annotate";

            "Mod+Space" = "keyboard-layout-next";
          };
        };
      };
    };
  };
}

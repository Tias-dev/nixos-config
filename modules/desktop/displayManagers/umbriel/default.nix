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
                match.app_id = "org.kde.kdeconnect.daemon";
                default_floating = true;
            }
            # {
            #   default_floating = true;
            #   "match.app_id" = "^dev.noctalia.Noctalia$";
            #   default_size = [1020 900];
            # }
          ];
          layer_rule = [
            {
              # "match.namespace" = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
              blur = true;
              blur_ignore_alpha = 0.5;
              blur_optimized = false;
            }
          ];
          layout = {
            extent_presets = [0.5 1.0];
          };

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
            cursor = {
                follows_focus = true;
                hide_when_typing = true;
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

            "Mod+Left" = "window-focus-left";
            "Mod+H" = "window-focus-left";
            "Mod+Down" = "window-focus-or-workspace-down";
            "Mod+J" = "window-focus-or-workspace-down";
            "Mod+Up" = "window-focus-or-workspace-up";
            "Mod+K" = "window-focus-or-workspace-up";
            "Mod+Right" = "window-focus-right";
            "Mod+L" = "window-focus-right";

            "Mod+Alt+Left" = "column-move-left";
            "Mod+Alt+H" = "column-move-left";
            "Mod+Alt+Down" = "column-move-to-workspace-next";
            "Mod+Alt+J" = "column-move-to-workspace-next";
            "Mod+Alt+Up" = "column-move-to-workspace-previous";
            "Mod+Alt+K" = "column-move-to-workspace-previous";
            "Mod+Alt+Right" = "column-move-right";
            "Mod+Alt+L" = "column-move-right";

            "Mod+1" = "workspace-switch:1";
            "Mod+2" = "workspace-switch:2";
            "Mod+3" = "workspace-switch:3";
            "Mod+4" = "workspace-switch:4";
            "Mod+5" = "workspace-switch:5";
            "Mod+6" = "workspace-switch:6";
            "Mod+7" = "workspace-switch:7";
            "Mod+8" = "workspace-switch:8";
            "Mod+9" = "workspace-switch:9";
            "Mod+0" = "workspace-switch:10";
            "Mod+Alt+1" = "column-move-to-workspace:1";
            "Mod+Alt+2" = "column-move-to-workspace:2";
            "Mod+Alt+3" = "column-move-to-workspace:3";
            "Mod+Alt+4" = "column-move-to-workspace:4";
            "Mod+Alt+5" = "column-move-to-workspace:5";
            "Mod+Alt+6" = "column-move-to-workspace:6";
            "Mod+Alt+7" = "column-move-to-workspace:7";
            "Mod+Alt+8" = "column-move-to-workspace:8";
            "Mod+Alt+9" = "column-move-to-workspace:9";
            "Mod+Alt+0" = "column-move-to-workspace:10";

            "Mod+Comma" = "window-consume-from-right";
            "Mod+Period" = "window-consume-or-expel-left";

            "Mod+V" = "window-focus-switch-floating";
            "Mod+F" = "window-toggle-fullscreen";
            "Mod+Alt+V" = "window-toggle-floating";
            "Mod+Alt+M" = "window-toggle-maximize";
            "Mod+Alt+N" = "window-toggle-maximize-to-edges";
            "Mod+Alt+P" = "window-toggle-pinned";
            "Mod+C" = "window-center";

            "Mod+R" = "window-cycle-primary-extent";
            "Mod+Shift+R" = "window-cycle-secondary-extent";

            "Mod+Ctrl+L" = "workspace-set-layout:toggle:scrolling,dwindle";

            "Mod+S" = "spawn:noctalia msg panel-toggle control-center";
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

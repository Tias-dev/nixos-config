{inputs, ...}: {
  flake.modules.homeManager.niri = {
    home-manager-standalone,
    lib,
    system,
    ...
  }: {
    systemd.user.services = lib.mkIf home-manager-standalone {
      dms.Service.ExecStart = lib.mkForce "nixGL ${inputs.dms.packages.${system}.default}/bin/dms run --session";
    };
    home.packages = [inputs.nixpkgs-unstable.legacyPackages.${system}.dankcalendar];
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      systemd.enable = true;
      settings = {
        springBounce = 0;
        motionEffect = 2;
        barElevationEnabled = false;
        workspaceDragReorder = false;
        reverseScrolling = true;
        workspaceNameIcons = {
          browser = {
            type = "icon";
            value = "home";
          };
          terminal = {
            type = "icon";
            value = "terminal";
          };
          chat = {
            type = "icon";
            value = "chat";
          };
          doc-viewer = {
            type = "icon";
            value = "photo";
          };
        };
        fontWeight = 900;
        showDock = true;
        dockSmartAutoHide = true;
        dockBorderThickness = 2;
        dockLauncherEnabled = true;
        dankIslandBarId = "default";
        dankIslandPalette = "dim";
        dankIslandSatellitePosition = "island";
        dankIslandReserveHeight = 31;
        dankIslandCompactHeight = 28;
        dankIslandOuterGap = 0;
        dankIslandCornerRadius = 10;
        dankIslandHomeLayout = [
          {
            id = "media";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "weather";
            enabled = false;
          }
          {
            id = "status";
            enabled = false;
          }
          {
            id = "volume";
            enabled = false;
          }
          {
            id = "brightness";
            enabled = false;
          }
          {
            id = "notifications";
            enabled = false;
          }
        ];
        dankIslandSatelliteBackground = true;
        dankIslandSatelliteSwoopRadius = 64;
        barConfigs = [
          {
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = 0;
            centerWidgets = [
              "music"
              "clock"
              "weather"
            ];
            enabled = true;
            fontScale = 1;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 0;
            leftWidgets = [
              "launcherButton"
              "workspaceSwitcher"
              "focusedWindow"
            ];
            name = "Main Bar";
            noBackground = true;
            openOnOverview = false;
            popupGapsAuto = true;
            popupGapsManual = 0;
            position = 0;
            rightWidgets = [
              {
                enabled = true;
                id = "systemTray";
              }
              {
                enabled = true;
                id = "clipboard";
              }
              {
                id = "cpuTemp";
                enabled = true;
                minimumWidth = true;
              }
              {
                enabled = true;
                id = "cpuUsage";
              }
              {
                enabled = true;
                id = "memUsage";
              }
              {
                enabled = true;
                id = "notificationButton";
              }
              {
                enabled = true;
                id = "battery";
              }
              {
                enabled = true;
                id = "vpn";
              }
              {
                enabled = true;
                id = "controlCenterButton";
              }
            ];
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            spacing = 4;
            squareCorners = false;
            transparency = 1;
            visible = true;
            widgetTransparency = 1;
            widgetPadding = 11;
            barInsetPadding = 7;
            iconScale = 1.25;
            maximizeWidgetIcons = false;
            maximizeWidgetText = false;
            removeWidgetPadding = false;
            widgetOutlineEnabled = false;
            widgetOutlineThickness = 1;
            widgetOutlineColor = "surfaceText";
          }
        ];
        desktopClockCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        systemMonitorCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
      };
      plugins = {
        dankBatteryAlerts.enable = true;
        dankPomodoroTimer.enable = true;
        dockerManager.enable = true;
        emojiLauncher.enable = true;
      };
    };
  };
}

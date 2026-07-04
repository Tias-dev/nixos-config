{inputs, ...}: {
  flake.modules.homeManager.niri = {pkgs, ...}: {
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
      niri = {
        enableSpawn = true;
      };
      settings = {
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            leftWidgets = [
              "launcherButton"
              "workspaceSwitcher"
              "focusedWindow"
            ];
            centerWidgets = [
              "music"
              "clock"
              "weather"
            ];
            rightWidgets = [
              {
                id = "systemTray";
                enabled = true;
              }
              {
                id = "clipboard";
                enabled = true;
              }
              {
                id = "cpuUsage";
                enabled = true;
              }
              {
                id = "memUsage";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
              {
                id = "battery";
                enabled = true;
              }
              {
                id = "vpn";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
            ];
            spacing = 4;
            innerPadding = 4;
            bottomGap = 0;
            transparency = 1;
            widgetTransparency = 1;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            fontScale = 1;
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
          }
        ];
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

{ pkgs, inputs, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = false;
    dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
		systemd = {
			enable = true;
			restartIfChanged = true;
		};
    plugins = {
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
      emojiLauncher.enable = true;
    };
  };

}

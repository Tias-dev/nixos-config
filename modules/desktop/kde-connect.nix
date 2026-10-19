{
  config.flake.modules = {
    homeManager.desktop = {
      services.kdeconnect.enable = true;
    };

    nixos.desktop = {config, username, ...}: {
      programs.ydotool.enable = true;
      users.users.${username}.extraGroups = [config.programs.ydotool.group];
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };
  };
}

{
  config.flake.modules.nixos.minecraft-server = {
    nixpkgs.config.allowUnfree = true;
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = "Plain minecraft servers on default nixos config";
        allow-cheats = false;
        online-mode = false;
      };
      jvmOpts = "-Xms256M -Xmx1024M";
    };
  };
}

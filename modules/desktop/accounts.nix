{
  config.flake.modules.nixos.desktop = {
    services.accounts-daemon.enable = true;
  };

  config.flake.modules.homeManager.desktop = {
    home.file.".face".source = ../../docs/account-image.png;
  };
}

{config, ...}: {
  config.flake.modules.nixos.remote-servers = {
    modulesPath,
    lib,
    pkgs,
    username,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./_generic/hardware-configuration.nix
    ];
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
      };
    };

    environment.systemPackages = map lib.lowPrio (with pkgs; [
      curl
      gitMinimal
      vim
      tmux
    ]);

    users.users = let
      ssh-config = {
        openssh.authorizedKeys.keys =
          config.flake.ssh-keys;
        initialHashedPassword = "$6$QnO.qxlgQ6te0gd2$yMVE8G83vQ7m5fv9roswV3Z7i2x5eHz3SFXjX1QItgLHqrlMvURKHe89jiKCZ.pArdZXq77LRCEyIsZ0QhC0l.";
      };
    in {
      root = ssh-config;
      ${username} =
        {
          isNormalUser = true;
          extraGroups = ["wheel" "networkmanager" "docker"];
        }
        // ssh-config;
    };
  };
}

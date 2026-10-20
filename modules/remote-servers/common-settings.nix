{
  config,
  inputs,
  ...
}: {
  config.flake.modules.nixos.remote-servers = {
    modulesPath,
    lib,
    pkgs,
    username,
    system,
    domain ? null,
    ...
  }: let
    neovim-light = inputs.tias-nixvim.packages.${system}.default;
  in {
    imports = [
      inputs.disko.nixosModules.disko
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
      ports = [10100];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    services.fail2ban.enable = true;

    environment.systemPackages = map lib.lowPrio (with pkgs; [
      curl
      gitMinimal
      neovim-light
      tmux
    ]);

    networking = {
      inherit domain;
    };
    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [ "root" "${username}" ];
    users.users = {
      ${username} = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "docker"];
        openssh.authorizedKeys.keys =
          config.flake.ssh-keys;
        initialHashedPassword = "$6$QnO.qxlgQ6te0gd2$yMVE8G83vQ7m5fv9roswV3Z7i2x5eHz3SFXjX1QItgLHqrlMvURKHe89jiKCZ.pArdZXq77LRCEyIsZ0QhC0l.";
      };
    };

    # for home-manager
    programs.dconf.enable = true;
  };
}

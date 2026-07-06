{config, ...}: {
  config.flake.modules.nixos.remote-servers = {
    modulesPath,
    lib,
    pkgs,
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
    services.openssh.enable = true;

    environment.systemPackages = map lib.lowPrio [
      pkgs.curl
      pkgs.gitMinimal
    ];

    users.users.root.openssh.authorizedKeys.keys =
        config.flake.ssh-keys;
  };
}

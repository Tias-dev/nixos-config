{
  config.flake.modules.nixos.virtualbox = {
    username,
    ...
  }: {
    config = {
      virtualisation = {
        virtualbox.host.enable = true;
      };
      users.extraGroups.vboxusers.members = [username];
    };
  };
}

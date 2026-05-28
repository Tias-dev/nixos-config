{config, ...}: {
  flake.modules.nixos.nix = {
    imports = [
      config.flake.modules.nixosModules.nix   
    ];
  };
}

{
  lib,
  config,
  inputs,
  ...
}: let
  mkNixos = system: cls: name: username:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        config.flake.modules.nixos.${cls}
        config.flake.modules.nixos."hosts/${name}"
        {
          home-manager.users.${username}.imports = [
            config.flake.modules.homeManager.homeManager
            (config.flake.modules.homeManager."hosts/${name}" or {})
          ];

          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
          system.stateVersion = "25.11";
        }
      ];
    };

  linux = mkNixos "x86_64-linux" "nixos";
in {
  flake.lib = {
    mkSystems = {
      inherit linux;
    };

    collectModules = config: modules:
      assert builtins.isAttrs config;
      assert builtins.isList modules;
      let
      user = config.flake.modules.homeManager.home.username;
      in (
        (map (module: config.flake.modules.nixos.${module} or {}) modules)
        ++ [
          {
            imports = [inputs.home-manager.nixosModules.home-manager];
            home-manager.users.${username}.imports =
              map (
                module: config.flake.modules.homeManager.${module} or {}
              )
              modules;
          }
        ]
      );
  };
}

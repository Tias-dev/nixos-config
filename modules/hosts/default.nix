{
  lib,
  config,
  inputs,
  ...
}: let
  # plain NixOS + Home manager setup
  mkNixos = system: cls: hostname: username:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit username;};
      modules = [
        config.flake.modules.nixos.${cls}
        config.flake.modules.nixos."hosts/${hostname}"
        {
          home-manager.users.${username}.imports = [
            config.flake.modules.homeManager.homeManager
            (config.flake.modules.homeManager."hosts/${hostname}" or {})
          ];

          networking.hostName = lib.mkDefault hostname;
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

  # Home manager only
  mkHomeManager = system: hostname: specialArgs:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        config.flake.modules.homeManager.homeManager
        (config.flake.modules.homeManager."hosts/${hostname}" or {})
      ];
      extraSpecialArgs = specialArgs;
    };

  # Manage system for not NixOS distro
  mkSystemManager = system: hostname:
    inputs.system-manager.lib.makeSystemConfig {
      modules = [
        {config = config.flake.modules.systemManager.systemManager.config;}
        {config = config.flake.modules.systemManager."hosts/${hostname}".config;}
      ];
    };

  linux = mkNixos "x86_64-linux" "nixos";
  linuxHMOnly = mkHomeManager "x86_64-linux";
  linuxSMOnly = mkSystemManager "x86_64-linux";

  collectTypedModules = type: config: modules:
    assert builtins.isAttrs config;
    assert builtins.isList modules; (map (module: config.flake.modules.${type}.${module} or {}) modules);
in {
  flake.lib = rec {
    mkSystems = {
      inherit linux linuxHMOnly linuxSMOnly;
    };

    collectNixosModules = collectTypedModules "nixos";
    collectHomeModules = collectTypedModules "homeManager";

    collectModules = config: modules: username:
      assert builtins.isAttrs config;
      assert builtins.isList modules; (
        (collectNixosModules config modules)
        ++ [
          {
            imports = [inputs.home-manager.nixosModules.home-manager];
            home-manager.users.${username}.imports = collectHomeModules config modules;
          }
        ]
      );
  };
}

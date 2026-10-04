{inputs}: let
  lib = inputs.nixpkgs.lib;
  mkConfiguration = {
    creationFunction,
    modules ? [],
  }:
    creationFunction {inherit modules;};

  collectTypedModules = {
    config,
    type,
    addSelfModule ? true,
  }: modules:
    (map (module: config.flake.modules.${type}.${module} or {}) modules)
    ++ (
      if addSelfModule
      then [(config.flake.modules.${type}.${type} or {})]
      else []
    );

  # plain NixOS + home-manager setup
  mkNixos = {
    hostname,
    username,
    system ? "x86_64-linux",
    class ? "nixos",
    addHomeManager ? true,
    modules ? [],
    ...
  } @ args: let
    extraArgs =
      {
        inherit hostname username system;
        home-manager-enabled = addHomeManager;
        home-manager-standalone = false;
      }
      // args;
  in
    mkConfiguration
    {
      creationFunction = inputs.nixpkgs.lib.nixosSystem;
      modules =
        [
          # args
          {config._module.args = extraArgs;}
          # nixos modules
          ({config, ...}: {
            imports =
              collectTypedModules {
                inherit config;
                type = class;
                addSelfModule = true;
              }
              modules;
          })
        ]
        # home-manager
        ++ (
          if addHomeManager
          then [
            inputs.home-manager.nixosModules.home-manager
            ({
              config,
              username,
              ...
            }: {
              home-manager.users.${username}.imports =
                [
                  {config._module.args = extraArgs;}
                ]
                ++ (collectTypedModules {
                    inherit config;
                    type = "homeManager";
                    addSelfModule = true;
                  }
                  modules);
            })
          ]
          else []
        );
    };
  # home-manager only
  mkHomeManager = {
    hostname,
    username,
    system ? "x86_64-linux",
    modules ? [],
  }:
    mkConfiguration {
      creationFunction = inputs.home-manager.lib.homeManagerConfiguration;
      modules = [
        {
          config._module.args = {
            inherit system hostname username;
            home-manager-standalone = true;
          };
        }
        ({config, ...}: {
          imports =
            collectTypedModules {
              inherit config;
              type = "homeManager";
              addSelfModule = true;
            }
            modules;
        })
      ];
    };

  # Manage system for not NixOS distro
  mkSystemManager = {
    hostname,
    username,
    system ? "x86_64-linux",
    modules ? [],
  }:
    mkConfiguration {
      creationFunction = inputs.system-manager.lib.makeSystemConfig;
      modules = [
        {config._module.args = {inherit system hostname username;};}
        ({config, ...}: {
          imports =
            collectTypedModules {
              inherit config;
              type = "systemManager";
              addSelfModule = true;
            }
            modules;
        })
      ];
    };
  getPersonalModuleName = {hostname}: "hosts/${hostname}";
  personalModule = {
    type,
    hostname,
    module,
  }: {
    flake.modules.${type}.${getPersonalModuleName hostname} = module;
  };
in rec {
  personalNixosModule = {
    hostname,
    module,
  }:
    personalModule {
      type = "nixos";
      inherit module hostname;
    };

  personalRemoteNixosModule = {
    hostname,
    domain ? null,
    module,
  }: let
    server-name =
      if domain != null
      then domain
      else hostname;
  in
    personalModule {
      type = "nixos";
      hostname = server-name;
      inherit module;
    };

  personalHomeManagerModule = {
    hostname,
    module,
  }:
    personalModule {
      type = "homeManager";
      inherit module hostname;
    };
  personalSystemManagerModule = {
    hostname,
    module,
  }:
    personalModule {
      type = "systemManager";
      inherit module hostname;
    };

  mkSystems = {
    linux = {
      hostname,
      username,
      modules ? [],
    }: let
      personaModuleName = getPersonalModuleName hostname;
      totalModules = modules ++ [personaModuleName];
    in {
      flake.nixosConfigurations.${hostname} = mkNixos {
        inherit username hostname;
        system = "x86_64-linux";
        modules = totalModules;
      };
    };

    remoteLinux = {
      hostname,
      username,
      domain ? null,
      modules ? [],
    }: let
      server-name =
        if domain != null
        then domain
        else hostname;
      personaModuleName = getPersonalModuleName server-name;
      totalModules = modules ++ [personaModuleName "remote-servers"];
    in
      lib.mkMerge [
        {
          flake.nixosConfigurations.${server-name} = mkNixos {
            inherit username hostname domain server-name;
            system = "x86_64-linux";
            modules = totalModules;
          };
        }
        # basic admin setup for better cli
        (personalHomeManagerModule {
          hostname = server-name;
          module = {system, ...}: {
            # light neovim without any lsp/formatter/treesitter binaries
            neovim-package = inputs.tias-nixvim.lib.neovimWithChangedOptions system {
              langChanger.enable = false;
            };
            imports = collectTypedModules {
              type = "homeManager";
              addSelfModule = false;
              modules = [
                "neovim"
                "zsh"
                "tmux"
              ];
            };
          };
        })
      ];

    linuxHomeManager = {
      hostname,
      username,
      modules ? [],
    }: let
      personaModuleName = getPersonalModuleName hostname;
      totalModules = modules ++ [personaModuleName];
    in {
      flake.homeConfigurations.${hostname} = mkHomeManager {
        inherit username hostname;
        system = "x86_64-linux";
        modules = totalModules;
      };
    };

    linuxSystemManager = {
      hostname,
      username,
      modules ? [],
    }: let
      personaModuleName = getPersonalModuleName hostname;
      totalModules = modules ++ [personaModuleName];
    in {
      flake.systemConfigs.${hostname} = mkSystemManager {
        inherit username hostname;
        system = "x86_64-linux";
        modules = totalModules;
      };
    };
  };
}

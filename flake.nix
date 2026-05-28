{
  description = "Tias/Raison/Timur-ux/my nixos config";
  # outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tias-nixvim = {
      url = "github:Tias-dev/nixvim-config/master";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs = {...} @ inputs: let
    hostname = "raison-nixos";
    username = "raison";
    system = "x86_64-linux";
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ];
      specialArgs = {
        inherit hostname username pkgs-unstable inputs;
      };
    };

    homeConfigurations.${username} = let
      vars = import ./home/vars.nix;
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [./home/home.nix];
        extraSpecialArgs = {inherit inputs vars pkgs-unstable system;};
      };
  };
}

{
  description = "Tias/Raison/Timur-ux/my nixos config";

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
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      hostname = "raison-nixos";
      username = "raison";
      system = "x86_64-linux";
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/${hostname}/configuration.nix ];
        specialArgs = {
          pkgs-unstable = unstable;
          inherit hostname username;
        };
      };

      homeConfigurations.${username} =
        let
          vars = import ./home/vars.nix;
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [ ./home/home.nix ];
          extraSpecialArgs = { inherit inputs vars; };
        };
    };
}

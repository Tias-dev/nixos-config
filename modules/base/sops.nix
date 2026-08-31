# HowTo !Imperatively! gen keys file(do on target machine on ${username} user):
# mkdir -p ~/.config/sops/age
# nix shell nixpkgs#age --command age-keygen -o ~/.config/sops/age/keys.txt
{inputs, ...}: let
  common-sops-opts = username: home-path: {
    sops = {
      # !Imperatively! place your age keys files on host :)
      age.keyFile = "${home-path}/${username}/.config/sops/age/keys.txt";
    };
  };
in {
  config.flake.modules = {
    nixos.sops = {
      username,
      pkgs,
      lib,
      config,
      ...
    }: {
      options = {
        sops-home-path = lib.mkOption {
          type = lib.types.str;
          default = "/home";
        };
      };
      imports = [
        inputs.sops-nix.nixosModules.default
        (common-sops-opts username config.sops-home-path)
      ];
      config = {
        environment.systemPackages = with pkgs; [sops];
      };
    };
    homeManager.sops = {
      username,
      pkgs,
      lib,
      config,
      ...
    }: {
      options = {
        sops-home-path = lib.mkOption {
          type = lib.types.str;
          default = "/home";
        };
      };
      imports = [
        inputs.sops-nix.homeManagerModules.default
        (common-sops-opts username config.sops-home-path)
      ];
      config = {
        home.packages = with pkgs; [sops];
      };
    };
  };
}

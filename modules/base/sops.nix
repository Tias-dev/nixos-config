# HowTo !Imperatively! gen keys file(do on target machine on ${username} user):
# mkdir -p ~/.config/sops/age
# nix shell nixpkgs#age --command age-keygen -o ~/.config/sops/age/keys.txt
{inputs, ...}: let
  common-sops-opts = username: {
    sops = {
      # !Imperatively! place your age keys files on host :)
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
  };
in {
  config.flake.modules = {
    nixos.sops = {username, pkgs, ...}: {
      imports = [
        inputs.sops-nix.nixosModules.default
        (common-sops-opts username)
      ];
      environment.systemPackages = with pkgs; [sops];
    };
    homeManager.sops = {username, pkgs, ...}: {
      imports = [
        inputs.sops-nix.homeManagerModules.default
        (common-sops-opts username)
      ];
      home.packages = with pkgs; [sops];
    };
  };
}

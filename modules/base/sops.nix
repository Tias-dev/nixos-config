{inputs, ...}: {
  flake.modules.nixos.sops = {username, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      # Imperatively place your age keys files on host :)
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
  };
}

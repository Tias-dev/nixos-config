{inputs, ...}: {
  flake.modules.nixos.nixos = {username, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      secrets.xrayConfig = {
        format = "json";
        sopsFile = ../../secrets/xray.json;
        key = "";
      };
    };
  };
}

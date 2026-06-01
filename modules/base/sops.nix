{inputs, ...}: {
  flake.modules.nixos.nixos = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      age.keyFile = "/home/raison/.config/sops/age/keys.txt";
      secrets.xrayConfig = {
        format = "json";
        sopsFile = ../../secrets/xray.json;
        key = "";
      };
    };
  };
}

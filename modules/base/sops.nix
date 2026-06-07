{inputs, ...}: {
  flake.modules.nixos.nixos = {config, ...}: 
  let
    username = config.flake.modules.homeManager.home.username;
  in {
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

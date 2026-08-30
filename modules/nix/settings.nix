let
  module = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };
in {
  flake.modules.nixos.nixos = module;
  flake.modules.nixos.remote-servers = module;
}

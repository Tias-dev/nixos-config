{
  # enable flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true; # collapse identical files in store in one
  };
}

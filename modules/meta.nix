{
  flake.meta = {
    terminal = {
      path = "kitty";
      name = "Kitty";
    };

    fileManager = {
      name = "dolphin";
      binPath = pkgs: "${pkgs.kdePackages.dolphin}/bin/dolphin";
    };
  };
}

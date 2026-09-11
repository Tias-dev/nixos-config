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

    xray-assets-path = "/usr/share/xray/assets/";
  };
}

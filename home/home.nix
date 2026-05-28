{
  pkgs,
  inputs,
  system,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "raison";
    homeDirectory = "/home/raison";
    stateVersion = "25.11";
    packages = import ./packages {inherit pkgs inputs system;};

    shell.enableFishIntegration = true;
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  imports = [
    ./modules
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.dms-plugin-registry.modules.default
    inputs.niri.homeModules.niri
    inputs.nixvim.homeModules.nixvim
  ];
}

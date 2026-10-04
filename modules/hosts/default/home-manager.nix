{inputs, ...}: {
  config.flake.modules.homeManager.homeManager = {
    pkgs,
    username,
    ...
  }: {
    nixpkgs.config.allowUnfree = true;
    home = {
      inherit username;
      packages = with pkgs; [home-manager];
      homeDirectory =
        if username != "root"
        then "/home/${username}"
        else "/root";
      stateVersion = "26.05";
    };
  };
}

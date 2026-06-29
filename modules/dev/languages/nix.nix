{
  flake.modules.homeManager.develop = {pkgs, ...}: {
    home.packages = with pkgs; [
      nix-output-monitor
    ];
  };
}

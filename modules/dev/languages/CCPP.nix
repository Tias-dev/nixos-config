{
  flake.modules.homeManager.develop = {pkgs, ...}: {
    home.packages = with pkgs; [
      gdb
      cmake
      gcc
      gnumake
      bear
    ];
  };
}

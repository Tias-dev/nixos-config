{
  flake.modules.homeManager.develop = {pkgs, ...}: {
    home.packages = with pkgs; [
      gdb
      cmake
      gcc
      gnumake
      bear
    ];
    home.file.".gdbinit".text = ''
      set print pretty on
      set print demangle on
      tui enable
    '';
  };
}

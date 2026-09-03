{
  config.flake.modules.homeManager.matrix-client = {pkgs, ...}: {
    home.packages = with pkgs; [
      element-desktop
    ];
    # provide extra argument to secrets manage. In other case element-desktop can't find it
    nixpkgs.overlays = [
      (final: prev: {
        element-desktop = pkgs.symlinkJoin {
          name = "element-desktop";
          paths = [prev.element-desktop];
          buildInputs = with pkgs; [makeWrapper];
          postBuild =
            /*
            bash
            */
            ''
              wrapProgram $out/bin/element-desktop --add-flag '--password-store "gnome-libsecret"'
            '';
        };
      })
    ];
  };
}

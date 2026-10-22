{inputs, ...}: {
  config.flake.modules = {
    nixos.mac-tahoe-gnome = {pkgs, ...}: {
      custom-greeter = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # To disable installing GNOME's suite of applications
      # and only be left with GNOME shell.
      services.gnome.core-apps.enable = false;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
      environment.systemPackages = with pkgs; [
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dash-to-dock
        gnomeExtensions.user-themes
      ];
    };
    homeManager.mac-tahoe-gnome = {
      pkgs,
      lib,
      system,
      ...
    }: let
      macTahoeGtk = inputs.mac-tahoe-gnome.packages.${system}.MacTahoe-gtk-theme;
      #
      # macTahoeIcons = pkgs.stdenv.mkDerivation rec {
      #   pname = "mactahoe-icon-theme";
      #   version = "latest";
      #
      #   src = pkgs.fetchFromGitHub {
      #     owner = "vinceliuice";
      #     repo = "MacTahoe-icon-theme";
      #     rev = "main";
      #     hash = "sha256-6a42HU49N4ChSm4AyW7i6FYAIENZzDogpZzM51muCbg="; # Replace with actual sha256
      #   };
      #   nativeBuildInputs = with pkgs; [bash];
      #
      #   installPhase = ''
      #     sed '/#!\/usr\/bin\/env/d' -i ./install.sh
      #     mkdir -p $out/share/icons
      #     bash -x ./install.sh -d $out/share/icons
      #   '';
      # };
    in {
      # # Install the custom built packages
      home.packages = [ macTahoeGtk ];

      #   # Apply the styling via Home Manager
        gtk = {
          enable = true;
          theme = lib.mkForce {
            name = "MacTahoe-Light"; # Or MacTahoe-Light
            package = macTahoeGtk;
          };
          # iconTheme = lib.mkForce {
          #   name = "MacTahoe";
          #   package = macTahoeIcons;
          # };
        };
    };
  };
}

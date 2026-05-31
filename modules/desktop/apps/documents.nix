{
  flake.modules.homeManager.documents = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.okular
      kdePackages.dolphin
      libreoffice
      zathura
    ];
  };
}

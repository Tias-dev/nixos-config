{
  flake.modules.homeManager.documents = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.okular
      libreoffice
      zathura
    ];
  };
}

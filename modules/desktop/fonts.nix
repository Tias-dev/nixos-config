{
  flake.modules.nixos.nixos = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      noto-fonts
      nerd-fonts.jetbrains-mono
    ];
  };
}

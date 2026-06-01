{vars, ...}: {
  # uncomment one of configurations
  # to use corresponding terminal emulator
  imports = [
    (
      if (vars.terminal == "alacritty")
      then ./alacritty.nix
      else ./kitty.nix
    )
  ];
}

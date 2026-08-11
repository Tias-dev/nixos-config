# Used on non nixos distros
# Reson in that on non nixos distros with home-manager only setups
# there is problem with PAM work. So we install swaylock via built-in package manager
# that handles PAM itself and in home-manager module only toggle per user config options
{
  config.flake.modules.homeManager.swaylock = {
      desktop.custom-lock-cmd = "swaylock"; # change lock cmd for niri keybinds
      programs.swaylock = {
        enable = true;
        package = null; # no package from nix as it is provided by built in package manager
      };
  };
}

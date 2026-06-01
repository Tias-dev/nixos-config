{
  pkgs,
  username,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ../../system
  ];

  nix = {
    settings.trusted-users = [
      "root"
      username
    ];
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  programs.firefox.enable = true;
  services.displayManager.ly.enable = true;
  services.xserver.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    openssl_4_0
    efivar
    cargo
    vim
    cachix
    wget
    curl
    ly
    python313
    (python313.withPackages (
      ps:
        with ps; [
          virtualenv
          pip
        ]
    ))
    nodejs_24
    zip
    unzip
    file
    git
    git-lfs
    cachix
    stow
    btop
    quickshell
    wl-mirror
    jq
    efibootmgr
    home-manager
    upower
    xwayland
    xwayland-satellite
  ];
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  programs.xwayland.enable = true;
  programs.fish.enable = true;
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
  };
  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono
  ];

  # List services that you want to enable:

  services.openssh.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

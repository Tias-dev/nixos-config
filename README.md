# My nixos config

My nixos config for all of my machines.

Configs for concrete hosts placed at `./modules/hosts/*`

## How to setup desktop on not NixOS linux

For correctly work on niri compositor you need to make following changes in your system by hand:

1. Change `/etc/environment` in order to preserve PATH env: `PATH=...:...:...` -> `PATH=$PATH:...:...:...`
2. Check niri binary in store: `ls -l $(which niri)`
3. Add to `$HOME/.config/environment.d/` file `15-path.conf` with output of following content: `PATH=/home/<username>/.nix-profile/bin:$PATH"`
4. TODO: Add niri.service and Co


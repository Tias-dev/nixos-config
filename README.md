# My nixos config

My nixos config for all of my machines.

Configs for concrete hosts placed at `./modules/hosts/`

Configs for my servers placed at `./modules/remote-servers/`

## How to setup desktop on not NixOS linux

For correctly work on niri compositor you need to make following changes in your system by hand:

1. Change `/etc/environment` in order to preserve PATH env: `PATH=...:...:...` -> `PATH=$PATH:...:...:...`
2. Check niri binary in store: `ls -l $(which niri)`
3. Add to `$HOME/.config/environment.d/` file `15-path.conf` with output of following content: `PATH=/home/<username>/.nix-profile/bin:$PATH"`
4. Add niri.service and niri-shutdown.target to `/etc/systemd/user/` folder
    1. niri.service:
    ```
    [Unit]
    Description=A scrollable-tiling Wayland compositor
    BindsTo=graphical-session.target
    Before=graphical-session.target
    Wants=graphical-session-pre.target
    After=graphical-session-pre.target

    Wants=xdg-desktop-autostart.target
    Before=xdg-desktop-autostart.target

    [Service]
    Slice=session.slice
    Type=notify
    ExecStart=/usr/bin/nixGL /usr/bin/niri --session
    ```


    2. niri-shutdown.target:
    ```
    [Unit]
    Description=Shutdown running niri session
    DefaultDependencies=no
    StopWhenUnneeded=true

    Conflicts=graphical-session.target graphical-session-pre.target
    After=graphical-session.target graphical-session-pre.target
    ```

5. Add links to nixGL and niri and niri-session from `/nix/store/` to `/usr/bin/`
6. Add wayland-session to `/usr/local/share/wayland-sessions/` niri.desktop:
```
[Desktop Entry]
Name=Niri
Comment=A scrollable-tiling Wayland compositor
Exec=/usr/bin/niri-session
Type=Application
DesktopNames=niri
```

## TODO

- [ ] Declare dashboard config for prometheus node exporter
- [ ] Add xray server service
- [ ] Add encrypted xray server fallback pages

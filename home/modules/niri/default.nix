{vars, ...}: {
  programs.niri.settings = {
    input = import ./input.nix;
    outputs = import ./outputs.nix;
    binds = import ./binds.nix {inherit vars;};
    workspaces = import ./workspaces.nix;
    window-rules = import ./window-rules.nix;
    spawn-at-startup = import ./startup.nix {inherit vars;};
    hotkey-overlay.skip-at-startup = true;
  };
}

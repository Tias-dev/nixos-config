let
  arcAliases = {
    ast = "arc status";
    aa = "arc add";
    ab = "arc branch";
    ac = "arc commit";
    acam = "arc commit --all --message";
    ack = "arc checkout";
    aapull = "arc pull";
    aapush = "arc push";
    arb = "arc rebase";
    arbc = "arc rebase --continue";
    ad = "arc diff";
    ads = "arc diff --staged";
  };
in
  {config, ...}: let
    inherit (config.flake.lib) mkTmuxSessionizerPkg;
  in {
    config.flake.modules.homeManager.arc = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit (pkgs.writers) writeBash;
      arc-branches = writeBash "arc-branches" ''
        wtPath="$HOME/arc-wt"
        configFile="$wtPath/config.json"
        wtFolders=$(cat "$configFile" | ${pkgs.jq}/bin/jq -r '.[] | .branch + "/" + .baseDir')
        for folder in $(echo "$wtFolders"); do
          echo "$wtPath/$folder"
        done
      '';
      arc-wt-sessionizer = pkgs.callPackage (mkTmuxSessionizerPkg arc-branches) {};
    in {
      programs.zsh = lib.mkIf config.programs.zsh.enable {shellAliases = arcAliases;};
      programs.fish = lib.mkIf config.programs.fish.enable {shellAliases = arcAliases;};
      programs.tmux.extraConfig = ''
        bind-key -r a run-shell "tmux neww ${arc-wt-sessionizer}"
      '';
    };
  }

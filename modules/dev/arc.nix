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
    awtab = "arc-wt-add-branch";
    awtrb = "arc-wt-remove-branch";
    awtrma = "arc-wt-remount-all";

    aml = "arc mount -l";
    amm = "arc mount --allow-other -m";
    aum = "arc umount";

    adtl = "arc difftool --tool='cmd:nvim -d $LOCAL $REMOTE'";
    amtl = "arc mergetool --tool='cmd:nvim -d $LOCAL $REMOTE $MERGED -c \'$wincmd w\' -c \'wincmd J\''";
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
      inherit (pkgs.writers) writeBash writeBashBin writePython3Bin;
      arc-wt-common = writeBash "arc-vars" ''
        wtPath="$HOME/arc-wt"
        configFile="$wtPath/config.json"
        mkdir -p "$wtPath"
        if [[ ! -f "$configFile" ]]; then
          echo "[]" > "$configFile"
        fi
        wtFolders=$(cat "$configFile" | ${pkgs.jq}/bin/jq -r '.[] | .branch + "/" + .baseDir')
        wtBranches=$(cat "$configFile" | ${pkgs.jq}/bin/jq -r '.[] | .branch')
      '';
      arc-branches = writeBash "arc-branches" ''
        source "${arc-wt-common}"
        for folder in $(echo "$wtFolders"); do
          echo "$wtPath/$folder"
        done
      '';
      arc-session-name-selector =
        writeBash "arc-session-name-selector"
        /*
        bash
        */
        ''
          echo "$1"
        '';
      arc-wt-sessionizer = pkgs.callPackage (mkTmuxSessionizerPkg arc-branches arc-session-name-selector) {};
      pyOpts = {flakeIgnore = ["E111"];};
      arc-wt-add-branch-impl = writePython3Bin "arc-wt-add-branch-impl" pyOpts ''
        import json
        import sys
        import os
        branchToAdd = sys.argv[1]
        baseDir = sys.argv[2]
        with open(os.getenv("configFile"), "r") as file:
          branches = json.load(file)
        for branch in branches:
          if branch == branchToAdd:
            print(f"Already exists: {branch}")
            exit(0)
        branches.append({"branch": branchToAdd, "baseDir": baseDir})
        with open(os.getenv("configFile"), "w") as file:
          json.dump(branches, file)
      '';
      arc-wt-add-branch = writeBashBin "arc-wt-add-branch" ''
        source "${arc-wt-common}"
        if [[ $# != 2 ]]; then
          echo "Usage: $0 <branch-name> <base-dir>"
          exit 1
        fi
        configFile="$configFile" ${arc-wt-add-branch-impl}/bin/arc-wt-add-branch-impl "$1" "$2"
        mkdir -p "$wtPath"/"$1"
        arc mount --allow-other -m "$wtPath"/"$1"
        cd "$wtPath"/"$1"
        arc branch $1
        arc checkout $1
      '';
      arc-wt-remove-branch-impl = writePython3Bin "arc-wt-remove-branch-impl" pyOpts ''
        import json
        import sys
        import os
        branchToDelete = sys.argv[1]
        with open(os.getenv("configFile"), "r") as file:
          branches = json.load(file)
        branches = list(filter(lambda x: x["branch"] != branchToDelete, branches))
        with open(os.getenv("configFile"), "w") as file:
          json.dump(branches, file)
      '';
      arc-wt-remove-branch = writeBashBin "arc-wt-remove-branch" ''
        source "${arc-wt-common}"
        if [[ $# == 1 ]]; then
          branch="$1"
        else
          branch="$(echo "$wtBranches" | fzf --header="Pick branch to remove:")"
        fi
        configFile="$configFile" ${arc-wt-remove-branch-impl}/bin/arc-wt-remove-branch-impl "$branch"
        arc umount "$wtPath"/"$branch"
        if [[ $? == 0 ]]; then
          rm -r "$wtPath"/"$branch"
        fi
      '';
      arc-wt-remount-all = writeBashBin "arc-wt-remount-all" ''
        source "${arc-wt-common}"
        for branch in $(echo "$wtBranches"); do
          echo "Try to mount: $branch"
          arc mount --allow-other "$wtPath/$branch"
        done
      '';
    in {
      programs.zsh = lib.mkIf config.programs.zsh.enable {shellAliases = arcAliases;};
      programs.fish = lib.mkIf config.programs.fish.enable {shellAliases = arcAliases;};
      programs.tmux.extraConfig = ''
        bind-key -r a run-shell "tmux neww ${arc-wt-sessionizer}"
      '';
      home.packages = [arc-wt-add-branch arc-wt-remove-branch arc-wt-remount-all];
    };
  }

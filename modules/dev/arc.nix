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
    };
in {
  config.flake.modules.homeManager.arc = {
    config,
    lib,
    ...
  }: {
    programs.zsh = lib.mkIf config.programs.zsh.enable {shellAliases = arcAliases;};
    programs.fish = lib.mkIf config.programs.fish.enable {shellAliases = arcAliases;};
  };
}

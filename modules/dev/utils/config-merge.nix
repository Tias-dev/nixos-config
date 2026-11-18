{config, ...}: {
  config.flake = {
    lib = {
      mkConfigMergeScript = pkgs:
        pkgs.writers.writePython3Bin "config-merger" {
          libraries = with pkgs.python3Packages; [
            pyyaml
          ];
          flakeIgnore = ["E111" "E501" "E721"];
        }
        /*
        python
        */
        ''
          import yaml
          import pathlib
          import argparse
          from typing import Dict, Any


          def merge(lhs_node: Dict[str, Any], rhs_node: Dict[str, Any]) -> None:
            if not isinstance(lhs_node, dict):
              raise RuntimeError(f"lhs_node: {lhs_node} is not a dict")
            if not isinstance(rhs_node, dict):
              raise RuntimeError(f"lhs_node: {rhs_node} is not a dict")
            for k, v in rhs_node.items():
              if k not in lhs_node:
                lhs_node[k] = v
                continue
              if type(lhs_node[k]) != type(rhs_node[k]):
                raise RuntimeError(f"Trying to merge different types! {type(lhs_node[k])} and {type(rhs_node[k])}")

              if isinstance(lhs_node[k], dict):
                merge(lhs_node[k], rhs_node[k])
              elif isinstance(lhs_node[k], list):
                lhs_node[k].extend(rhs_node[k])
              else:
                lhs_node[k] = rhs_node[k]


          def main():
            parser = argparse.ArgumentParser(description="merge yaml configs(right merge)")
            parser.add_argument("main_file", type=pathlib.Path)
            parser.add_argument("additional_file", type=pathlib.Path)

            args = parser.parse_args()

            with open(args.main_file, "r") as file:
              lhs_node = yaml.load(file, Loader=yaml.CLoader)

            with open(args.additional_file) as file:
              rhs_node = yaml.load(file, Loader=yaml.CLoader)

            merge(lhs_node, rhs_node)

            print(yaml.dump(lhs_node, Dumper=yaml.CDumper))

            return 0


          if __name__ == "__main__":
            exit(main())
        '';
    };

    modules.homeManager.config-merge = {pkgs, ...}: {
      home.packages = [(config.flake.lib.mkConfigMergeScript pkgs)];
    };
  };
}

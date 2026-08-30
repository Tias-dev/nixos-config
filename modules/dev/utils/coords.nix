{
  config.flake.modules.homeManager.coords = {pkgs, ...}: let
    fetchLongFloatNumbers =
      pkgs.writers.writePython3Bin "fetchLongFloatNumbers" {flakeIgnore = ["E111" "E501"];}
      /*
      python
      */
      ''
        import sys
        import re
        import argparse

        parser = argparse.ArgumentParser(description="Find numbers like 123.12342345, -12313.423 etc")
        parser.add_argument("-p", "--paired", action="store_true", help="Display numbers in pairs")
        parser.add_argument("-s", "--separator", default=" ", type=str, help="separator to use with -p")
        args = parser.parse_args()

        text = sys.stdin.read()
        pattern = r"-?\d+\.\d+"
        numbers = map(float, re.findall(pattern, text))
        if not args.paired:
          for number in numbers:
            print(float(number))
        else:
          for i, number in enumerate(numbers):
            if i % 2 == 0:
              print(number, end=args.separator)
            else:
              print(number)
      '';
  in {
    home.packages = [fetchLongFloatNumbers];
  };
}

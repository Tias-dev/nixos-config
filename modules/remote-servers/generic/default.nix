{configurations-lib, ...}: let
  hostname = "generic";
in {
  config = configurations-lib.mkSystems.remoteLinux {
    inherit hostname;
    username = "default";
  };
}

{configurations-lib, config, ...}: let
  hostname = "generic";
in {
  config = ( configurations-lib.mkSystems config).remoteLinux {
    inherit hostname;
    username = "default";
  };
}

{lib, ...}: {
  flake.modules.homeManager.terminal = {
    options.terminal = lib.mkOption {
      type = lib.types.submodule {
	options = {
	  name = lib.mkOption {
	    type = lib.types.str;
	    desc = "Terminal name";
	  };
	  path = lib.mkOption {
	    type = lib.types.str;
	    desc = "Path to terminal program";
	  };
	};
	desc = "Terminal configuration";
      };
    };
  };
}

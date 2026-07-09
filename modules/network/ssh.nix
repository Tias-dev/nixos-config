{lib, ...}: {
  options.flake.ssh-keys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of public ssh keys used to add to remote servers for ssh connection";
  };
}

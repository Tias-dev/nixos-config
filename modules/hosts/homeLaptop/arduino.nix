{configurations-lib, ...}: {
  config = configurations-lib.personalNixosModule {
    hostname = "laptop-tias";
    module = {username, ...}: {
      users.users.${username}.extraGroups = [ "dialout" ]; # to be able to upload ardiuno brains over /dev/tty<some> port
    };
  };
}

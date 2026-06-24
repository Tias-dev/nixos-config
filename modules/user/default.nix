{
  flake.modules.homeManager.homeManager = {username, ...}: {
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = "26.05";
    };
  };
}

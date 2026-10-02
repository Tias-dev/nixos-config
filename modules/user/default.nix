{
  flake.modules.homeManager.homeManager = {username, ...}: {
    home = {
      inherit username;
      homeDirectory = if username != "root" then "/home/${username}" else "/${username}";
      stateVersion = "26.05";
    };
  };
}

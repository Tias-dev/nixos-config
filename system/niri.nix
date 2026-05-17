{
  programs.niri = {
    enable = true;
  };
  # prebuild binary setup
  # it required via the building niri from sources
  # is very long and invokes file descriptors overflow on my setup
  nix.settings = {
    substituters = [
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };
}

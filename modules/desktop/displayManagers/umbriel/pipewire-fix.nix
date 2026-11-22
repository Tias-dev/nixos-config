{
  config.flake.modules.homeManager.umbriel = {
    xdg.configFile."pipewire/pipewire.conf.d/99-disable-x11-bell.conf".text = ''
      context.properties = {
        module.x11.bell = false
      }
    '';
  };
}

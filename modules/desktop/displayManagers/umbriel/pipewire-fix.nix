{
  config.flake.modules.nixos.umbriel = let
    conf = {
      context.modules = [
        {
          name = "libpipewire-module-x11-bell";
          flags = ["ifexists" "nofail"];
          condition = [{module.x11.bell = false;}];
        }
      ];
    };
  in
    {
      config,
      lib,
      ...
    }: {
      services.pipewire.extraConfig = lib.mkIf config.services.pipewire.enable {
        pipewire = {
          "no-x11-bell" = conf;
        };
        pipewire-pulse = {
          "no-x11-bell" = conf;
        };
      };
    };
}

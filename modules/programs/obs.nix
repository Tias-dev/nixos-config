{inputs, ...}: {
  flake.modules.homeManager.recording = {
    system,
    pkgs,
    ...
  }: {
    programs.obs-studio = {
      enable = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgs.obs-studio-plugins; [
        inputs.tias-nixpkgs.packages.${system}.obs-face-tracker
        input-overlay
      ];
    };
  };
}

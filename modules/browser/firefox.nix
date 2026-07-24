{
  options = {lib, ...}: let
    bookmark-type =
      lib.types.submodule {
        options
      };
  in {
    extra-bookmarks = lib.mkOption bookmark-type;
  };

  config = {
    flake.modules.homeManager.browser = {
      programs.firefox = {
        enable = true;
        languagePacks = ["ru" "en-US"];
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
          SearchBar = "unified"; # alternative: "separate"

          ExtensionSettings = {
            "*".installation_mode = "blocked";
            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4717567/vimium_ff-2.4.2.xpi";
            };
          };
        };

        profiles = {
          tias-dev = {
            id = 0;
            isDefault = true;
          };
        };
      };
    };
  };
}

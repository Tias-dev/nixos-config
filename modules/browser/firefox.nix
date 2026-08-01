{
  config = {
    flake.modules.homeManager.browser = {
      lib,
      config,
      ...
    }: let
      bookmark-type = with lib;
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              description = "Bookmark name.";
            };
            tags = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Bookmark tags.";
            };
            keyword = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Bookmark search keyword.";
            };
            url = mkOption {
              type = types.str;
              description = "Bookmark url, use %s for search terms.";
            };
          };
        };
      separator-type = lib.types.enum ["separator"];
      directory-type = with lib;
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              description = "Directory name.";
            };
            bookmarks = mkOption {
              type = types.listOf node-type;
              default = [];
              description = "Bookmarks within directory.";
            };
          };
        };
      node-type = lib.types.oneOf [
        directory-type
        bookmark-type
        separator-type
      ];
    in {
      options = {
        firefox.extra-bookmarks = lib.mkOption {
          # just lib.types.listOf node-type dont work but it must be lib.types.listOf node-type!
          type = lib.types.listOf lib.types.raw;
          default = [];
        };
      };
      config = let
        default-bookmarks = [
          {
            name = "nix";
            bookmarks = [
              {
                name = "Nix Search";
                url = "https://search.nixos.org";
                tags = ["nix" "search"];
              }
              {
                name = "Home-manager options";
                url = "https://home-manager-options.extranix.com";
                tags = ["nix" "home-manager" "search"];
              }
            ];
          }
        ];
      in {
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
            DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
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
              bookmarks = {
                settings = [
                  {
                    name = "toolbar";
                    toolbar = true;
                    bookmarks =
                      default-bookmarks
                      ++ (lib.optionals (config.firefox.extra-bookmarks != []) ["separator"] ++ config.firefox.extra-bookmarks);
                  }
                ];
                force = true;
              };
            };
          };
        };
      };
    };
  };
}

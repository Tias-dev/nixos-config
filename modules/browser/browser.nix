{inputs, ...}: {
  config = {
    flake.modules.homeManager.browser = {
      lib,
      config,
      pkgs,
      system,
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
        browser = {
          extra-bookmarks = lib.mkOption {
            # just lib.types.listOf node-type dont work but it must be lib.types.listOf node-type!
            type = lib.types.listOf lib.types.raw;
            default = [];
          };
          use-zen-browser = lib.mkEnableOption "Zen browser instead of firefox";
          package-raw = lib.mkOption {
            type = lib.types.package;
            default = pkgs.firefox;
            description = "raw package to be wraped with extra config";
          };
          package = lib.mkOption {
            type = lib.types.package;
            description = "Wrapped package with config applied";
          };
          package-name = lib.mkOption {
            type = lib.types.str;
            description = "Package name(by default evaluated automatically from lib.getExe config.browser.package)";
          };
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
        get-binary-from-package = pkg: lib.lists.last (lib.strings.split "/" (lib.getExe pkg));
      in {
        browser = {
          use-zen-browser = lib.mkDefault true;
          package-raw =
            lib.mkIf config.browser.use-zen-browser inputs.zen-browser.packages.${system}.zen-browser-unwrapped;
          package-name = get-binary-from-package config.browser.package;
          package =
            pkgs.wrapFirefox
            config.browser.package-raw
            {
              extraPolicies = {
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
            };
        };
        home.packages = [
          config.browser.package
        ];
      };
    };
  };
}

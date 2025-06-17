{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.firefox;

  # Lock values for Firefox policies
  lock-false = { Value = false; Status = "locked"; };
  lock-true = { Value = true; Status = "locked"; };

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" "ru" ];
      # User specific settings
      profiles.${config.primaryUser} = {
        settings = {
          "browser.tabs.closeWindowWithLastTab" = false;
          # Enable userChrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # Enable compact mode in UI
          "browser.compactmode.show" = true;
          # Set compact density
          "browser.uidensity" = 1;
          # Hide bookmarks in toolbar
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.bookmarks.restore_default_bookmarks" = false; # Corrected typo
          # Don't show warn
          "browser.aboutConfig.showWarning" = false;
          # This JSON string defines the placement of all toolbar items.
          # We place only the urlbar and extensions button on the nav-bar.
          # Other items are moved to the overflow menu.
          "browser.uiCustomization.state" = ''
            {
              "placements": {
                "widget-overflow-fixed-list": [
                  "downloads-button",
                  "history-panelmenu",
                  "find-button",
                  "fxa-toolbar-menu-button",
                  "firefox-view-button",
                  "back-button",
                  "forward-button",
                  "stop-reload-button",
                  "home-button"
                ],
                "nav-bar": [
                  "urlbar-container",
                  "unified-extensions-button"
                ],
                "toolbar-menubar": ["menubar-items"],
                "TabsToolbar": [
                  "tabbrowser-tabs",
                  "new-tab-button",
                  "alltabs-button"
                ],
                "PersonalToolbar": []
              },
              "seen": [
                "save-to-pocket-button",
                "developer-button",
                "unified-extensions-button"
              ],
              "dirtyAreaCache": [
                "nav-bar",
                "toolbar-menubar",
                "TabsToolbar",
                "PersonalToolbar",
                "widget-overflow-fixed-list"
              ],
              "currentVersion": 22,
              "newElementCount": 0
            }
          '';
          # Hide sidebar
          "sidevar.visibility" = "hide-sidebar";
          # Don't trigger menu bar on <Alt> key press
          "ui.key.menuAccessKeyFocuses" = false;
        };
        # Apply one-line firefox theme
        userChrome = builtins.readFile ./userChrome.css;
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
        Preferences = {
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };
    };
  };

in {
  options.modules.firefox = {
    enable = mkEnableOption "Enable Firefox with configuration";
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}

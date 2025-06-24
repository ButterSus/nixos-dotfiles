# Inspired by: https://github.com/oddlama/nix-config/blob/main/users/myuser/graphical/firefox.nix
# And also: https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.firefox;
  
  # List of extensions
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    vimium-c
    i-dont-care-about-cookies
    darkreader
    
    # Catppuccin
    catppuccin-mocha-mauve
    catppuccin-web-file-icons
  ];

  # Core home configuration for this module
  moduleHomeConfig = {
    # Home Manager Options for this module
    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" "ru" ];
      # User specific settings
      profiles.${config.primaryUser} = {
        # ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
        settings = {
          ##################
          ## FIRST LAUNCH ##
          ##################

          # Don't show guidance
          "app.normandy.first_run" = false;
          "trailhead.firstrun.branches" = "nofirstrun-empty";
          "browser.aboutwelcome.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.uitour.enabled" = false;

          # Don't show warn
          "browser.aboutConfig.showWarning" = false;
          # Enable extensions by default
          "extensions.autoDisableScopes" = 0;
          # Don't update extensions
          "extensions.update.enabled" = false;

          #####################
          ## QOL PREFERENCES ##
          #####################

          # Resume previous session
          "browser.statup.page" = 3;
          # Don't restore default bookmarks
          "browser.bookmarks.restore_default_bookmarks" = false;

          # My personal preference for closing last tab
          "browser.tabs.closeWindowWithLastTab" = false;
          # Don't sort tabs
          "browser.ctrlTab.sortByRecentlyUsed" = false;

          # Ask folder destination download to
          "browser.download.useDownloadDir" = false;
          # I know language gud
          "browser.translation.neverTranslateLanguages" = "ru";
          # Save history on exit
          "privacy.clearOnShutdown.history" = false;
          # Disable bell sounds
          "accessibility.typeaheadfind.enablesound" = false;
          # Enable autoscroll
          "general.autoScroll" = true;
          # Don't trigger menu bar on <Alt> key press
          "ui.key.menuAccessKeyFocuses" = false;
          # ESNI is deprecated ECH is recommended
          "network.dns.echconfig.enabled" = true;

          # Disable Pocket
          "extensions.pocket.enabled" = false;
          # Disable Screenshots
          "extensions.screenshots.disabled" = true;
          # Disable Top Sites
          "browser.topsites.contile.enabled" = false;
          # Disable Form Filling
          "browser.formfill.enable" = false;
          # Disable Search Suggestions
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          # Disable Search Suggestions in URL Bar
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          # Disable Top Stories
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          # Disable Pocket
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          # Disable Bookmarks
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          # Disable Downloads
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          # Disable Visited
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          # Disable Sponsored
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Enable Firefox login
          "identity.fxaccounts.enabled" = true;
          "identity.fxaccounts.toolbar.enabled" = true;
          "identity.fxaccounts.pairing.enabled" = true;
          "identity.fxaccounts.commands.enabled" = true;

          # Disable annoying web features
          "dom.push.enabled" = false;
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.private-attribution.submission.enabled" = false;
          # HIDDEN PREF: disable recommendation pane in about:addons (uses Google Analytics)
          "extensions.getAddons.showPane" = false;
          # recommendations in about:addons' Extensions and Themes panes [FF68+]
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          
          # Better F11 (Don't go to fullscreen state)
          "full-screen-api.ignore-widgets" = true;
          
          #############
          ## PRIVACY ##
          #############

          # Disable telemetry
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;

          # Don't be part of tests
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          # Enable bluetooth location (required for perplexity.ai)
          "beacon.enabled" = true;

          # Disable geolocation alltogether
          "geo.enabled" = false;
          # Use strict privacy
          "browser.contentblocking.category" = "strict";

          # Additional protection
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          
          ####################
          ## USER INTERFACE ##
          ####################

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
                "preferences-button",
                "stop-reload-button",
                "home-button"
              ],
              "unified-extensions-area": [
                "vimium-c_gdh1995_cn-browser-action",
                "jid1-kkzogwgsw3ao4q_jetpack-browser-action"
              ],
              "nav-bar": [
                "urlbar-container",
                "unified-extensions-button",
                "vertical-spacer",
                "forward-button",
                "back-button"
              ],
              "toolbar-menubar": [
                "menubar-items"
              ],
              "TabsToolbar": [
                "tabbrowser-tabs",
                "new-tab-button",
                "alltabs-button"
              ],
              "vertical-tabs": [],
              "PersonalToolbar": []
            },
            "seen": [
              "save-to-pocket-button",
              "developer-button",
              "unified-extensions-button",
              "vimium-c_gdh1995_cn-browser-action",
              "jid1-kkzogwgsw3ao4q_jetpack-browser-action"
            ],
            "dirtyAreaCache": [
              "nav-bar",
              "toolbar-menubar",
              "TabsToolbar",
              "PersonalToolbar",
              "widget-overflow-fixed-list",
              "unified-extensions-area",
              "vertical-tabs"
            ],
            "currentVersion": 22,
            "newElementCount": 1
          }
          '';

          # Enable userChrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # Enable compact mode in UI
          "browser.compactmode.show" = true;
          # Set compact density
          "browser.uidensity" = 1;
          # Hide bookmarks in toolbar
          "browser.toolbars.bookmarks.visibility" = "never";
          # Hide sidebar
          "sidebar.visibility" = "hide-sidebar";

          # Set theme
          "extensions.activeThemeID" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
          "extensions.extensions.activeThemeID" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
        };
        extensions = {
          # Extensions from NUR
          packages = extensions;

          # Unfortunately, extension settings are really hard to set
          # the "Nix way". So we must set them manually via GUI.
          # https://github.com/nix-community/home-manager/pull/6389
        };
        # Apply one-line firefox theme
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };

in {
  options.modules.firefox = {
    enable = mkEnableOption "Enable Firefox with configuration";
  };

  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}

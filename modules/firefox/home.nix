# Inspired by: https://github.com/oddlama/nix-config/blob/main/users/myuser/graphical/firefox.nix
# And also: https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
# And also: https://github.com/Misterio77/nix-config/blob/main/home/gabriel/features/desktop/common/firefox.nix
{ config, lib, pkgs, isHMStandaloneContext, ... }:

# Your browser has the most sensitive data on your computer, so it would make
# sense to acknowledge yourself with available search engines, and disabled
# firefox telemetry listed here.

# Here is other tutorial about it: https://brainfucksec.github.io/firefox-hardening-guide

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.firefox;
  
  # List of extensions, you can browse them here:
  # https://nur.nix-community.org/repos/rycee/
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    # Luckily, these extensions support storage.js -> declarative extension settings
    ublock-origin
    vimium-c
    firefox-color

    i-dont-care-about-cookies

    # NOTE: You'll manually need to override colors:
    # https://github.com/catppuccin/dark-reader?tab=readme-ov-file#usage
    darkreader

    # NOTE: You'll manually need to add catppuccin userstyles:
    # https://github.com/catppuccin/userstyles/blob/main/docs/USAGE.md
    stylus
  ];

  # Core home configuration for this module
  moduleHomeConfig = {
    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };

    # Home Manager Options for this module
    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" ];
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

          # Allow extensions to run in private windows
          "extensions.allowPrivateBrowsingByDefault" = true;

          # Set extensions to work on restricted domains
          "extensions.enabledScopes" = 5;
          "extensions.webextensions.restrictedDomains" = "";

          # Allow extensions on restricted sites
          "extensions.webextensions.base-content-security-policy" = "";
          "extensions.webextensions.default-content-security-policy" = "";

          # Display always the installation prompt
          "extensions.postDownloadThirdPartyPrompt" = false;

          # Disable auto-installing firefox updates
          "app.update.background.scheduling.enabled" = false;
          "app.update.auto" = false;

          # Resume previous session
          "browser.startup.page" = 3;
          # If startup page was 1 (home), use this url
          "browser.startup.homepage" = "about:home";
          # Don't restore default bookmarks
          "browser.bookmarks.restore_default_bookmarks" = false;

          # My personal preference for closing last tab
          "browser.tabs.closeWindowWithLastTab" = false;
          # Don't sort tabs
          "browser.ctrlTab.sortByRecentlyUsed" = false;

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

          # Disable Top Sites
          "browser.topsites.contile.enabled" = false;
          # Disable Top Stories
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          # Another telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
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
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Disable Firefox login
          "identity.fxaccounts.enabled" = false;
          "identity.fxaccounts.toolbar.enabled" = false;
          "identity.fxaccounts.pairing.enabled" = false;
          "identity.fxaccounts.commands.enabled" = false;

          # Disable annoying web features
          "dom.push.enabled" = false;
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.private-attribution.submission.enabled" = false;
          # HIDDEN PREF: disable recommendation pane in about:addons (uses Google Analytics)
          "extensions.getAddons.showPane" = false;
          # recommendations in about:addons' Extensions and Themes panes [FF68+]
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;
          
          # Better F11 (Don't go to fullscreen state)
          "full-screen-api.ignore-widgets" = true;
          
          #############
          ## PRIVACY ##
          #############

          # Set DuckDuckGo as default search engine - use the exact engine name (deprecated)
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.selectedEngine" = "DuckDuckGo";
          
          # Alternative approach - use search order preference (deprecated)
          "browser.search.order.1" = "DuckDuckGo";

          # WARN: This feature disables dark theme, so I don't enable this option.
          ## Enable RFP (Fingerprint protection)
          # "privacy.resistFingerprinting" = true;

          # WARN: Your window size also can be used as fingerprint,
          # typical suggestion would be to round window size, however for convenience
          # i dont care lmao.

          # WARN: DNS over HTTPS is disabled here, you better go use VPN
          # rather than trying to hide DNS requests.

          # Disable mozAddonManager Web API
          "privacy.resistFingerprinting.block_mozAddonManager" = true;

          # Disable using system colors
          "browser.display.use_system_colors" = false;

          # Disable showing about:blank page when possible at startup
          "browser.startup.blankWindow" = false;

          # Disable search suggestions
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.search.suggest.searches" = false;

          # Disable location bar domain guessing
          "browser.fixup.alternate.enabled" = false;

          # Display all parts of the url in the bar
          "browser.urlbar.trimURLs" = false;

          # Disable location bar making speculative connections
          "browser.urlbar.speculativeConnect.enabled" = false;

          # Disable form autofill
          "browser.formfill.enable" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.available" = "off";
          "extensions.formautofill.creditCards.available" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.formautofill.heuristics.enabled" = false;

          # Disable location bar contextual suggestions
          "browser.urlbar.quicksuggest.scenario" = "history";
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;

          # Disable saving passwords
          "signon.rememberSignons" = false;

          # Disable autofill login and passwords
          "signon.autofillForms" = false;

          # Disable formless login capture for Password Manager
          "signon.formlessCapture.enabled" = false;

          # Hardens against potential credentials phishing:
          # "don't allow cross-origin sub-resources to open HTTP authentication crdentials dialogs"
          "network.auth.subresource-http-auth-allow" = 1;

          # Complete password management disable
          "signon.generation.enabled" = false;                 # Don't generate passwords
          "signon.management.page.breach-alerts.enabled" = false; # No breach alerts
          "signon.firefoxRelay.feature" = "disabled";         # Disable Firefox Relay integration

          # Disable disk cache
          "browser.cache.disk.enable" = false;
          
          # Disable storing extra session data: nowhere
          "browser.sessionstore.privacy_level" = 2;
          
          # Disable resuming session from crash
          "browser.sessionrestore.resume_from_crash" = false;

          # Disable page thumbnail collection
          "browser.pagethumbnails.capturing_disabled" = true;

          # Disable favicons in profile folder
          "browser.shell.shortcutFavicons" = false;
          
          # Delete temporary files opened with external apps
          "browser.helperApps.deleteTempFileOnExit" = true;

          # Enable HTTPS-Only mode in all windows
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;

          # Disable sending HTTP request for checking HTTPS support by the server
          "dom.security.https_only_mode_send_http_background_request" = false;

          # Display advanced information on Insecure Connection warning pages
          "browser.xul.error_pages.expert_bad_cert" = true;

          # Disable TLS1.3 0-RTT (round-trip time)
          "security.tls.enable_0rtt_data" = false;

          # Set OCSP to terminate the connection when a CA isn't validate;
          "security.OCSP.require" = true;
          # Disable SHA-1 certificates
          "security.pki.sha1_enforcement_level" = 1;

          # Enable strict pinning (PKP (Public Key Pinning)): strict
          "security.cert_pinning_enforcement_level" = 2;

          # Enable CRLite: "consult CRLite and enforce both 'Revoked' and 'Not Revoked' results"
          "security.remote_settings.crlite_filters_enabled" = true;
          "security.pki.crlite_mode" = 2;

          # Control when to send a referer: only if hosts match
          "network.http.referer.XOriginPolicy" = 2;

          # Control the amount of information to send: minimal
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          # WARN: Please, disable WebRTC options below if audio/voice communication stopped working for you in services.

          # Disable WebRTC
          "media.peerconnection.enabled" = false;

          # Force WebRTC inside the proxy
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

          # Force a single network interface for ICE candidates generation
          "media.peerconnection.ice.default_address_only" = true;

          # Force exclusion of private IPs from ICE candidates
          "media.peerconnection.ice.no_host" = true;

          # Disable WebGL (can expose your GPU)
          "webgl.disabled" = true;

          # Disable autoplay of HTML5 media: block all
          "media.autoplay.default" = 5;

          # Disable DRM Content
          "media.eme.enabled" = false;

          # Always ask you where to save files
          "browser.download.useDownloadDir" = false;

          # Disable adding downloads to system's "recent documents" list
          "browser.download.manager.addToRecentDocs" = false;

          # Enable ETP (Enhanced Tracking Protection), ETP strict mode
          # enables Total Cookie Protection (TCP)
          "browser.contentblocking.category" = "strict";

          # Enable state partitioning of service workers
          "privacy.partition.serviceWorkers" = true;

          # Enable APS (Always Partitioning Storage)
          "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
          "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;

          # URL bar settings (deprecated)
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;

          # Geolocation
          "browser.search.geoSpecificDefaults" = false;
          "browser.search.geoSpecificDefaults.url" = "";

          # I'm kinda lazy about this, but you can enable it though, if you have API.
          ## Use Mozilla geolocation service instead of Google if permission is granted
          # geo.provider.network.url = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

          # Disable using the OS's geolocation service
          "geo.provider.ms-windows-location" = false;
          "geo.provider.use_corelocation" = false;
          "geo.provider.use_gpsd" = false;
          "geo.provider.use_geoclue" = false;

          # Disable geolocation alltogether
          "geo.enabled" = false;

          # Disable region updates
          "browser.region.network.url" = "";
          "browser.region.update.enabled" = false;

          # Set language for displaying web pages
          "intl.accept_languages" = "en-US, en";
          "javascript.use_us_english_locale" = true;

          # Ensure no region-specific search defaults
          "browser.search.region" = "US";
          "browser.search.isUS" = true;

          # Disable telemetry
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "extensions.webcompat-reporter.enabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;

          # Don't be part of tests
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;

          # WARN: Disable this one, however, some websites won't work
          "beacon.enabled" = true;

          # Disable crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;

          # Disable captive portal detection
          "captivedetect.canonicalURL" = "";
          "network.captive-portal-service.enabled" = false;

          # Disable network connections checks
          "network.connectivity-service.enabled" = false;

          # WARN: Safe Browsing is enabled here, you might disable it.
          # However IMHO, it's better to have it.

          # Disable link prefetching
          "network.prefetch-next" = false;

          # Disable DNS prefetching
          "network.dns.disablePrefetch" = true;

          # Disable predictors
          "network.predictor.enabled" = false;

          # Disable link-mouseover opening connection to linked server
          "network.http.speculative-parallel-limit" = 0;

          # Disable mousedown speculative connections on bookmarks and history
          "browser.places.speculativeConnect.enabled" = false;

          # Disable IPv6
          "network.dns.disableIPv6" = true;

          # Disable GIO protocols as a potential proxy bypass vectors
          "network.gio.supported-protocols" = "";

          # Disable using UNC paths (prevent proxy bypass)
          "network.file.disable_unc_paths" = true;

          # Remove special premissions for certain mozilla domains
          "permissions.manager.defaultsUrl" = "";

          # Use Punycode in Internationalized Domain Names to eliminate possible spoofing
          "network.IDN_show_punycode" = true;

          # Additional protection
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;

          ####################
          ## USER INTERFACE ##
          ####################

          # Block popup windows
          "dom.disable_open_during_load" = true;

          # Limit events that can cause a popup
          "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";

          # Disable Pocket extension
          "extensions.pocket.enabled" = false;

          # Disable Screenshots extension
          "extensions.screenshots.disabled" = true;

          # Disable PDFJS scripting
          "pdfjs.enableScripting" = false;

          # Show the UI settings
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          # Hide bookmarks in toolbar
          "browser.toolbars.bookmarks.visibility" = "never";
          # Force dark theme if possible
          "layout.css.prefers-color-scheme.content-override" = 0;
        };

        # Extensions from NUR
        extensions = {
          packages = extensions;
          force = true;

          # To find extension ID, please look here:
          # about:debugging#/runtime/this-firefox
          settings = {
            # To find extension storage, look at <mozilla-folder>/firefox/<profile>/browser-extension-data/<extension-id>/storage.js

            # Sidebery
            "{3c078156-979c-498b-8990-85f7987dd929}".settings.settings = {
              density = "compact";
              "activateAfterClosingStayInPanel" = true;
            };

            # Vimium C
            "vimium-c@gdh1995.cn".settings = {
              keyMappings = "#!no-check\nunmap <c-e>\nunmap <c-y>";
            };
          };
        };
        
        # Use DuckDuckGo, please!
        search = {
          force = true;
          default = "ddg";
          order = [ "ddg" ];
          engines = {
            "google".metaData.hidden = true;
          };
        };
      };
    };

    # Apply textfox firefox theme
    textfox = {
      enable = true;
      profile = config.primaryUser;
      config = {
        displaySidebarTools = true;
        displayNavButtons = true;
      };
    };

    catppuccin.firefox.profiles.${config.primaryUser} = {
      enable = true;
      force = true;
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

{ lib, config, pkgs, ... }:
lib.mkIf config.programs.firefox.enable {
  programs.firefox = {
    profiles = {
      default = {
        settings = {
          # UI
          "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.tabs.tabmanager.enabled" = false; # hide dropdown tab menu
          "browser.tabs.tabClipWidth" = 999; # clip tab close button on inactive tabs
          "browser.compactmode.show" = true; # compact UI density
          "browser.uidensity" = 1; # enable compact UI
          "extensions.pocket.enabled" = false;
          "apz.overscroll.enabled" = true;

          # fonts
          "font.name.monospace.x-western" = "CaskaydiaCove Nerd Font";
          "font.name.sans-serif.x-western" = "Calibri";
          "font.name.serif.x-western" = "Cambria";
          "font.size.variable.x-western" = 14;

          #"extensions.activeThemeID" = "default-theme@mozilla.org";
          #"browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"save-to-pocket-button\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":2}";

          # Privacy and security
          "app.shield.optoutstudies.enabled" = false; # Disallow Firefox to install and run studies
          "browser.contentblocking.category" = "standard"; # Enhanced Tracking Protection
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = true; # Allow Firefox to send backlogged crash reports
          "browser.xul.error_pages.expert_bad_cert" = true; # display advanced information on Insecure Connection warning pages
          "dom.security.https_only_mode" = true;
          "network.auth.subresource-http-auth-allow" = 1; # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources. Hardens against potential credentials phishing
          "security.cert_pinning.enforcement_level" = 2; # 2=strict. Public key pinning prevents man-in-the-middle attacks due to rogue CAs [certificate authorities] not on the site's list
          "security.dialog_enable_delay" = 700; # enforce a security delay on some confirmation dialogs such as install, open/save
          "security.insecure_field_warning.contextual.enabled" = true; # Show in-content login form warning UI for insecure login fields
          "security.insecure_password.ui.enabled" = true; # show a warning that a login form is delivered via HTTP (a security risk)
          "security.mixed_content.block_active_content" = true; # disable insecure active content on https pages (mixed content) (might not be needed with HTTPS-Only Mode enabled)
          "security.mixed_content.block_display_content" = true; # disable insecure passive content (such as images) on https pages, "Parts of this page are not secure (such as images)"
          "security.mixed_content.upgrade_display_content" = true; # Try to load HTTP content as HTTPS (in mixed content pages)
          "security.pki.crlite_mode" = 2; # switching from OCSP to CRLite for checking sites certificates which has compression, is faster, and more private. 2="CRLite will enforce revocations in the CRLite filter, but still use OCSP if the CRLite filter does not indicate a revocation" (https://www.reddit.com/r/firefox/comments/wesya4/danger_of_disabling_query_ocsp_option_in_firefox/, https://blog.mozilla.org/security/2020/01/09/crlite-part-2-end-to-end-design/)
          "security.ssl.require_safe_negotiation" = true; # Blocks connections to servers that don't support RFC 5746 as they're potentially vulnerable to a MiTM attack

          # Behavior
          "intl.regional_prefs.use_os_locales" = true; # Use your OS settings to format dates, times, etc.
          "browser.download.always_ask_before_handling_new_types" = true;
          "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
          "general.autoScroll" = true;
          "signon.rememberSignons" = false; # Ask to save passwords
          "browser.startup.page" = 3; # Resume previous browser session
          "browser.search.suggest.enabled" = true;
          "browser.urlbar.suggest.searches" = true;
          "media.block-autoplay-until-in-foreground" = true;
          "media.block-play-until-document-interaction" = true;
          "media.block-play-until-visible" = true;
        };
        extensions = [];
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "SpeQtral SharePoint" = {
              urls = [{ template = "https://speqtralquantum.sharepoint.com/_layouts/15/search.aspx/?q={searchTerms}"; }];
              definedAliases = [ "q" ];
            };
            "Google".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
        userChrome = "";
      };
    };
  };
}

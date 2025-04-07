{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    profiles = {
      default = {
        settings = {
          # UI
          "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.tabmanager.enabled" = false; # hide dropdown tab menu
          "browser.tabs.tabClipWidth" = 999; # clip tab close button on inactive tabs
          "browser.compactmode.show" = true; # compact UI density
          "browser.uidensity" = 1; # enable compact UI
          "browser.uiCustomization.state" = builtins.toJSON {
            "placements" = {
              "nav-bar" = [
                "userchrome-toggle_joolee_nl-browser-action"
                "sync-button"
                "customizableui-special-spring1"
                "back-button"
                "stop-reload-button"
                "forward-button"
                "urlbar-container"
                "downloads-button"
                "unified-extensions-button"
                "customizableui-special-spring3"
              ];
              "toolbar-menubar" = ["menubar-items"];
              "unified-extensions-area" = builtins.map (
                extId: let
                  lowercaseId = lib.toLower extId;
                  sanitizedId = let
                    illegalCharacters = ["{" "}" "@" "."];
                    replacements = builtins.map (x: "_") illegalCharacters;
                  in
                    builtins.replaceStrings illegalCharacters replacements lowercaseId;
                in "${sanitizedId}-browser-action"
              ) (builtins.attrNames config.programs.firefox.policies.ExtensionSettings);
            };
            "dirtyAreaCache" = [
              "unified-extensions-area"
              "nav-bar"
              "toolbar-menubar"
            ];
            "currentVersion" = 20;
          };
          "extensions.pocket.enabled" = false;
          "apz.overscroll.enabled" = true;
          # for arcwtf
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "uc.tweak.hide-forward-button" = true;
          "uc.tweak.popup-search" = false;
          "uc.tweak.longer-sidebar" = true;

          # fonts
          "font.size.variable.x-western" = 14;

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
          "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "MyNixOS" = {
              urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
              definedAliases = ["mn"];
            };
            "NixHub" = {
              urls = [{template = "https://www.nixhub.io/packages/{searchTerms}";}];
              definedAliases = ["nh"];
            };
            "Minecraft Wiki" = {
              urls = [{template = "https://minecraft.wiki/?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";}];
              definedAliases = ["mc"];
            };
            "SpeQtral SharePoint" = {
              urls = [{template = "https://speqtralquantum.sharepoint.com/_layouts/15/search.aspx/?q={searchTerms}";}];
              definedAliases = ["q"];
            };
            "GitHub" = {
              urls = [{template = "https://github.com/{searchTerms}";}];
              definedAliases = ["gh"];
            };
            "Lenovo PSREF" = {
              urls = [{template = "https://psref.lenovo.com/Search?kw={searchTerms}";}];
              definedAliases = ["psref"];
            };
            "Google".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
      };
    };
    policies = {
      ExtensionSettings = let
        extensions = installation_mode:
          builtins.mapAttrs (
            _: slug: {
              inherit installation_mode;
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${slug}/latest.xpi";
            }
          );
      in
        (extensions "force_installed" {
          "ATBC@EasonWong" = "adaptive-tab-bar-colour";
          "{bda3a2e1-851d-4bf9-83c1-0d1ac026a675}" = "bible-previewer";
          "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
          "gdpr@cavi.au.dk" = "consent-o-matic";
          "{0fb022fc-3f93-42d8-9789-100037ae1801}" = "copy-image-as-base64";
          "FirefoxColor@mozilla.com" = "firefox-color";
          "keepassxc-browser@keepassxc.org" = "keepassxc-browser";
          "{3c078156-979c-498b-8990-85f7987dd929}" = "sidebery";
          "userchrome-toggle@joolee.nl" = "userchrome-toggle";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = "videospeed";
          "{4d9d2bcc-7acd-404b-8c8c-b1ac947facfc}" = "consent-o-matic";
        })
        // (extensions "blocked" {
          "amazondotcom@search.mozilla.org" = "";
          "bing@search.mozilla.org" = "";
          "google@search.mozilla.org" = "";
          "wikipedia@search.mozilla.org" = "";
        });
      Containers = {
        Default = [
          {
            name = "Microsoft Jail";
            color = "blue";
            icon = "briefcase";
          }
          {
            name = "Google Jail";
            color = "red";
            icon = "pet";
          }
          {
            name = "Facebook Jail";
            color = "toolbar";
            icon = "chill";
          }
        ];
      };
    };
  };
  stylix.targets.firefox.profileNames = ["default"];
  home.file = let
    inherit (pkgs.stdenv.hostPlatform) isDarwin;
    cfg = config.programs.firefox;
    configPath = ".mozilla/firefox";
    profilesPath =
      if isDarwin
      then "${configPath}/Profiles"
      else configPath;
    defaultProfilePath = "${profilesPath}/${cfg.profiles.default.path}/chrome";
  in {
    ${defaultProfilePath} = {
      recursive = false;
      source = flake.inputs.arcwtf;
    };
  };
}

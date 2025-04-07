{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-chinese-addons # chinese input
        fcitx5-lua # for sj/rq macros
        fcitx5-pinyin-zhwiki # dictionary from chinese Wikipedia
        catppuccin-fcitx5 # theme
      ];
      settings = {
        addons = {
          classicui.globalSection = {
            Theme = "catppuccin-latte-blue";
            DarkTheme = "catppuccin-mocha-blue";
            UseDarkTheme = "True";
            UseAccentColor = "True";
          };
        };
        globalOptions = {
          "Hotkey/TriggerKeys" = {"0" = "Control+space";};
          "Hotkey/AltTriggerKeys" = {"0" = "Shift_L";};
          "Hotkey/PrevPage" = {"0" = "Up";};
          "Hotkey/NextPage" = {"0" = "Down";};
          Behavior = {ShareInputState = "All";};
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            "DefaultIM" = "pinyin";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "pinyin";
            Layout = "";
          };
          "GroupOrder" = {"0" = "Default";};
        };
      };
    };
  };

  fonts.packages = builtins.attrValues {
    inherit
      (pkgs)
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      source-han-mono
      ;
  };
}

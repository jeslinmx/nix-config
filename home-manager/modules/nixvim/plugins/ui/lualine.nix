{
  programs.nixvim.plugins.lualine = {
    enable = true;
    extensions = [];
    sections = {
      lualine_a = [
        {
          name = "mode";
          padding = 0;
          separator = { left = ""; right = " "; };
          fmt = ''
            function(str) return ({
              NORMAL = "",
              INSERT = "󰏫",
              COMMAND = ":",
              VISUAL = "󰈈",
              ['V-LINE'] = "󱀦",
              ['V-BLOCK'] = "󱈝",
              SELECT = "",
              ['S-LINE'] = "",
              ['S-BLOCK'] = "󰒅",
              REPLACE = "󰯍",
              ['V-REPLACE'] = "󰾵",
              TERMINAL = "",
              ['O-PENDING'] = "…",
              EX = "E",
              MORE = "",
              CONFIRM = ">",
              SHELL = "$"
            })[str] end
          '';
        }
      ];
      lualine_b = [
        { name = "branch"; separator.left = ""; }
        "diff"
      ];
      lualine_c = [
        {
          name = "filetype";
          padding = { left = 1; right = 0; };
          extraConfig = { icon_only = true; draw_empty = true; };
        }
        { name = "filename";
          padding = { left = 0; right = 1; };
          extraConfig = {
            newfile_status = true;
            path = 1;
            symbols = { modified = "󰏫"; readonly = "󰏯"; newfile = ""; };
          };
        }
        "encoding"
        "fileformat"
      ];
      lualine_x = [
        "searchcount"
        "selectioncount"
      ];
      lualine_y = [
        "progress"
        { name = "location"; separator.right = ""; }
      ];
      lualine_z = [
        { name = "diagnostics"; separator = { left = ""; right = " "; }; extraConfig.draw_empty = true; }
      ];
    };
    sectionSeparators = {
      left = "";
      right = "";
    };
    componentSeparators = {
      left = "";
      right = "";
    };
  };
}

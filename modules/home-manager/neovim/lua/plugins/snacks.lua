return {
  "folke/snacks.nvim",

  opts = {
    dashboard = {
      sections = {
        { section = "keys", gap = 1, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
          limit = 10,
          cwd = true,
        },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          enabled = function()
            return require("snacks").git.get_root() ~= nil
          end,
          key = "b",
          action = function()
            require("snacks").gitbrowse()
          end,
        },
        function()
          local in_git = require("snacks").git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Git Status",
              cmd = "git status --short --branch --renames",
              height = 5,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 3,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 3,
            },
            {
              title = "Github Notifications",
              cmd = "gh notify -s -a -n" .. ((in_git and 5) or 24),
              action = function()
                vim.ui.open "https://github.com/notifications"
              end,
              key = "n",
              icon = " ",
              height = (in_git and 5) or 24,
              enabled = true,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
      preset = {
        keys = {
          { icon = " ", key = "e", desc = "Empty buffer", action = ":ene" },
          { icon = " ", key = "s", desc = "Restore session", section = "session" },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = "",
      },
    },
    terminal = {},
    scroll = {},
    quickfile = {},
    toggle = {},
    indent = {
      enabled = true,
      scope = { enabled = true },
      chunk = {
        enabled = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          arrow = "┤",
        },
      },
    },
    dim = {},
  },

  lazy = false,
}

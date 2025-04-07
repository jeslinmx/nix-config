return {
  "gbprod/substitute.nvim",

  opts = {
    yank_substituted_text = true,
    highlight_substituted_text = { timer = 300 },
    preserve_cursor_position = true,
  },

  keys = {
    {
      "gr",
      function()
        require("substitute").operator()
      end,
      desc = "Substitute from register",
    },
    {
      "grr",
      function()
        require("substitute").line()
      end,
      desc = "Entire line",
    },
    {
      "gR",
      function()
        require("substitute").eol()
      end,
      desc = "Substitute to end of line",
    },
    {
      "gr",
      function()
        require("substitute").visual()
      end,
      "v",
      desc = "Substitute selection from register",
    },
    {
      "gx",
      function()
        require("substitute.exchange").operator()
      end,
      desc = "Exchange",
    },
    {
      "gxx",
      function()
        require("substitute.exchange").line()
      end,
      desc = "Exchange line",
    },
    {
      "gX",
      function()
        require("substitute.exchange").eol()
      end,
      desc = "Exchange to end of line",
    },
    {
      "gx",
      function()
        require("substitute.exchange").visual()
      end,
      "v",
      desc = "Exchange selection",
    },
  },
}

return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },

  opts = {
    cmdline = {
      view = "cmdline",
      format = {
        cmdline = false,
        search_up = { icon = " " },
        search_down = { icon = " " },
        help = { icon = "?" },
      },
    },
    popupmenu = { enabled = false },
  },

  event = "VeryLazy",
}

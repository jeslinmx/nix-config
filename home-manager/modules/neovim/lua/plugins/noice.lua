return {
  "MunifTanjim/nui.nvim",
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = false,
          search_up = { icon = " " },
          search_down = { icon = " " },
          help = { icon = "?" }
        }
      },
      commands = {
        history = { view = "popup" },
        last = { view = "notify" },
      }
    },
    dependencies = { "MunifTanjim/nui.nvim" }
  }
}

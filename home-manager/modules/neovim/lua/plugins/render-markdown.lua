return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },

  opts = {
    heading = {
      icons = {},
      signs = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      width = "block",
      left_margin = 1,
      left_pad = 2,
      right_pad = 2,
      border = true,
    },
    code = {
      position = "right",
      width = "block",
      min_width = 50,
      left_margin = 1,
      left_pad = 2,
      right_pad = 2,
      inline_pad = 1,
      border = "thick",
    },
  },

  ft = { "markdown", "latex", "html" },
}

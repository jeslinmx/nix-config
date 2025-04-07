return {
  "hiphish/rainbow-delimiters.nvim",
  config = function()
    require("rainbow-delimiters.setup").setup {
      strategy = { [""] = require("rainbow-delimiters").strategy["local"] },
    }
  end,
  event = "BufEnter",
}

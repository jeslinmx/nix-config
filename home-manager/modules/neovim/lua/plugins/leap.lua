return {
  "ggandor/leap.nvim",
  keys = {
    { "s", mode = { "n", "o" }, desc = "leap forward" },
    { "S", mode = { "n", "o" }, desc = "leap backward" },
    { "gs", mode = { "n", "o" }, desc = "Leap from Windows" },
  },
  config = function(_, opts)
    local leap = require("leap")
    for k, v in pairs(opts) do
      leap.opts[k] = v
    end
    leap.add_default_mappings(true)
    vim.keymap.set({'n', 'o'}, 'gs', function ()
      require('leap.remote').action()
    end)
    vim.keymap.del({ "x", "o" }, "x")
    vim.keymap.del({ "x", "o" }, "X")
  end,
}

return {
  "utilyre/barbecue.nvim",
  dependencies = { "SmiteshP/nvim-navic" },

  config = function()
    require("barbecue").setup {
      create_autocmd = false, -- prevent barbecue from updating itself automatically
    }

    vim.api.nvim_create_autocmd({
      "WinResized",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
      "BufModifiedSet",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,

  event = { "WinResized", "BufWinEnter", "CursorHold", "InsertLeave", "BufModifiedSet" },
}

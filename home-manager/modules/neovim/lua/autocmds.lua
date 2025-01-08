local highlightyank = vim.api.nvim_create_augroup("highlightyank", {})
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight on yank",
  pattern = "*",
  group = highlightyank,
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})

local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  desc = "Relative line numbers outside of insert mode",
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  desc = "Absolute line numbers in insert mode",
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})

-- reminder: use `:noautocmd w` to override this for a single save
local conform = vim.api.nvim_create_augroup("conform", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format on save",
  pattern = "*",
  group = conform,
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= "" then
      return
    end
    require("conform").format { buffer = args.buf }
  end,
})

local showkeys = vim.api.nvim_create_augroup("showkeys", {})
vim.api.nvim_create_autocmd({ "UIEnter" }, {
  desc = "Enable showkeys",
  group = showkeys,
  callback = function()
    require("showkeys").toggle()
  end,
})

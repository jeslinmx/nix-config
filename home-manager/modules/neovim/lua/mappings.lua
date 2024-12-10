local map = vim.keymap.set

map("i", "<C-a>", "<Home>", { desc = "move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move to end of line" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<cr>", { desc = "clear highlights" })

map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "copy whole file" })

-- map("n", "<leader>fm", function()
--   require("conform").format { lsp_fallback = true }
-- end, { desc = "general format file" })

-- global lsp mappings
-- map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "buffer new" })
map("n", "<leader>bq", require("nvchad.tabufline").close_buffer, { desc = "buffer close" })
map("n", "<tab>", require("nvchad.tabufline").next, { desc = "buffer goto next" })
map("n", "<S-tab>", require("nvchad.tabufline").prev, { desc = "buffer goto prev" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "nvimtree focus window" })

-- terminal
map("i", "jj", "<Esc>", { desc = "escape insert mode" })
map("t", "jj", "<C-\\><C-N>", { desc = "escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <cr>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

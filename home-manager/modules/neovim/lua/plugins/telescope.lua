return {
  "nvim-telescope/telescope.nvim",
  opts = {
    path_display = "filename_first",
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("nerdy")
    require("telescope").load_extension("undo")
  end,
  dependencies = { "2kabhishek/nerdy.nvim", "debugloop/telescope-undo.nvim" },
  keys = {
    -- { "<leader><leader>a", "<cmd>Telescope autocommands<cr>", desc = "autocommands" },
    { "<leader><leader>b", "<cmd>Telescope buffers<cr>", desc = "buffers" },
    -- { "<leader><leader>c", "<cmd>Telescope commands<cr>", desc = "commands" },
    { "<leader><leader>f", "<cmd>Telescope find_files<cr>", desc = "files" },
    { "<leader><leader>F", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "all files" },
    { "<leader><leader>r", "<cmd>Telescope live_grep<cr>", desc = "ripgrep" },
    { "<leader><leader>:", "<cmd>Telescope command_history<cr>", desc = "command history" },
    { "<leader><leader>h", "<cmd>Telescope help_tags<cr>", desc = "help" },
    { "<leader><leader>j", "<cmd>Telescope jumplist<cr>", desc = "jumps" },
    { "<leader><leader>m", "<cmd>Telescope man_pages<cr>", desc = "man" },
    { "<leader><leader>n", "<cmd>Telescope nerdy<cr>", desc = "nerdglyphs" },
    { "<leader><leader>t", "<cmd>Telescope terms<cr>", desc = "terminals" },
    { "<leader><leader>q", "<cmd>Telescope oldfiles<cr>", desc = "recently closed" },
    { "<leader><leader>u", "<cmd>Telescope undo<cr>", desc = "undotree" },
    { "<leader><leader>o", "<cmd>Telescope vim_options<cr>", desc = "options" },
    { "<leader><leader>'", "<cmd>Telescope marks<cr>", desc = "marks" },
    { "<leader><leader>\"", "<cmd>Telescope registers<cr>", desc = "registers" },
    { "<leader><leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "current buffer (fuzzy)" },

    { "<leader><leader>gc", "<cmd>Telescope git_bcommits<cr>", desc = "commits (current file)" },
    { "<leader><leader>gc", "<cmd>Telescope git_bcommits_range<cr>", mode = { "o", "v" }, desc = "commits (range)"},
    { "<leader><leader>gC", "<cmd>Telescope git_commits<cr>", desc = "commits (working dir)" },
    { "<leader><leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
    { "<leader><leader>gf", "<cmd>Telescope git_files<cr>", desc = "files" },
    { "<leader><leader>gs", "<cmd>Telescope git_stash<cr>", desc = "stash" },
    { "<leader><leader>gd", "<cmd>Telescope git_status<cr>", desc = "diff/status" },
  }
}



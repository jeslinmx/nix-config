return { "nvim-telescope/telescope.nvim",
  dependencies = { "2kabhishek/nerdy.nvim", "debugloop/telescope-undo.nvim" },

  opts = {
    path_display = "filename_first",
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("nerdy")
    require("telescope").load_extension("undo")
  end,

  cmd = "Telescope",
}



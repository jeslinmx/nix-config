return {
  { "stevearc/oil.nvim",
    opts = {
      columns = { "size", "mtime", "icon" },
      buf_options = {
        buflisted = true
      }
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {{ "-", "<cmd>Oil<cr>", desc = "browse containing folder" }}
  },
}

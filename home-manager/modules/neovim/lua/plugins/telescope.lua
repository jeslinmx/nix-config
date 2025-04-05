return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "2kabhishek/nerdy.nvim", "debugloop/telescope-undo.nvim" },

  opts = {
    defaults = {
      layout_strategy = "flex",
      layout_config = {
        prompt_position = "top",
        horizontal = {
          preview_width = 0.6,
        },
        vertical = {
          width = 0.999,
          preview_height = 0.6,
          mirror = true,
        },
      },
      sorting_strategy = "ascending",
      path_display = {
        "filename_first",
        -- shorten = { len = 2, exclude = {1, -2, -1} },
        "truncate",
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "nerdy"
    require("telescope").load_extension "undo"
  end,

  cmd = "Telescope",
}

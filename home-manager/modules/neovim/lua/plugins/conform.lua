return {
  "stevearc/conform.nvim",

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      -- css = { "prettier" },
      -- html = { "prettier" },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = "fallback",
    },
  },

  event = "BufWritePre",
}

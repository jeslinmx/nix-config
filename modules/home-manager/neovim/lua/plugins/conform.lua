return {
  "stevearc/conform.nvim",

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      -- css = { "prettier" },
      -- html = { "prettier" },
    },

    default_format_opts = {
      timeout_ms = 500,
      lsp_fallback = "fallback",
    },
  },

  event = "BufWritePre",
}

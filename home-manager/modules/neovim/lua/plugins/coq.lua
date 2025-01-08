return {
  "ms-jpq/coq_nvim",
  branch = "coq",
  dependencies = {
    { "ms-jpq/coq.artifacts", branch = "artifacts" },
    { "ms-jpq/coq.thirdparty", branch = "3p" },
  },

  init = function()
    vim.g.coq_settings = {
      auto_start = true,
      completion = {
        skip_after = { "(", ")", "{", "}", "[", "]" },
      },
      display = {
        pum = {
          fast_close = false,
        },
        preview = {
          border = "rounded",
        },
      },
    }
  end,
  config = function()
    require "coq_3p" {
      { src = "repl", sh = "bash" },
      { src = "nvimlua", short_name = "nLUA", conf_only = false },
      { src = "bc", short_name = "MATH", precision = 6 },
      { src = "codeium", short_name = "COD" },
      -- { src = "dap" },
    }
  end,
}

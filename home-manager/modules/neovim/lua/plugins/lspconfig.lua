return { "neovim/nvim-lspconfig",
  dependencies = {
    "ms-jpq/coq_nvim",
  },

  config = function()
    local lspconfig = require("lspconfig")
    local servers = { "html", "cssls", "gopls", "pylsp", "nixd", "lua_ls" }

    local on_attach = function(client, bufnr) end

    local on_init = function(client, bufnr)
      if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    -- lsps with default config
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup(require("coq").lsp_ensure_capabilities{
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
      })
    end

    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.fn.expand "$VIMRUNTIME/lua",
              vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
              vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
              "${3rd}/luv/library",
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    }
  end,

  event = { "BufReadPost", "BufNewFile" },
}

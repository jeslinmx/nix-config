return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "ms-jpq/coq_nvim",
    "b0o/schemastore.nvim",
  },

  config = function()
    local lspconfig = require "lspconfig"
    local servers = { "ansiblels", "bashls", "gopls", "lua_ls", "nixd" }

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
      lspconfig[lsp].setup(require("coq").lsp_ensure_capabilities {
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

    lspconfig.nixd.setup {
      settings = {
        nixd = {
          options = {
            nixos = {
              expr = '(builtins.getFlake "github:jeslinmx/nix-config").nixosConfigurations.jeshua-xps-9510.options',
            },
            -- home_manager = {
            --   expr = '',
            -- },
          },
        },
      },
    }

    lspconfig.jsonls.setup {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas {
            description = "Fastfetch config file schema",
            fileMatch = "config.jsonc",
            name = "fastfetch",
            url = "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/doc/json_schema.json",
          },
          validate = { enable = true }, -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
        },
      },
    }

    lspconfig.yamlls.setup {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" }, -- disable builtin support
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    }
  end,

  event = { "BufReadPost", "BufNewFile" },
}

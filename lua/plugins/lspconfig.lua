

return {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
        "mason-org/mason.nvim",
        {
            "neovim/nvim-lspconfig",
            setup = {
                -- Patch all servers
                ["*"] = function(_, opts)
                    opts.capabilities = opts.capabilities or {}
                    opts.capabilities.offsetEncoding = { "utf-8" }
                end,
            },config = function()
 -- require('lspconfig').html.setup{
 --   cmd = { "vtsls", "--stdio" },
 --   filetypes = { "html" },
 --   root_dir = require('lspconfig.util').root_pattern(".git", vim.fn.getcwd()),
 -- }
require('lspconfig').vtsls.setup {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue","html" },
  root_dir = require('lspconfig.util').root_pattern("tsconfig.json", "jsconfig.json", ".git"),
  settings = {
    typescript = {
      implicitProjectConfig = {
        checkJs = true
      }
    },
    javascript = {
      implicitProjectConfig = {
        checkJs = true
      }
    },
    vtsls = {
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true
        }
      }
    }
  },
}
--require("lspconfig").ts_ls.setup{ filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html" } }
--require("lspconfig").volar.setup{ filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html" } }
    end

        },
    },
    opts = {
        ensure_installed = {
            "rust_analyzer", -- Rust
            "clangd",        -- C, C++
            "ts_ls", -- JavaScript, TypeScript
            "vue_ls",
            "vtsls",
            "html",          -- HTML
            "cssls",         -- CSS
            "texlab"
        },
        automatic_installation = true,
        servers = {

            clangd = {
                capabilities = {

                    offsetEncoding = { "utf-8" },
                },
            },

        },
    },
    settings = {
        ["luau-lsp"] = {
            diagnostics = {
                globals = { "vim" },
            },
        },
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Tell LSP that `vim` is a global variable
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files for better completion
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        }
    }
    ,}

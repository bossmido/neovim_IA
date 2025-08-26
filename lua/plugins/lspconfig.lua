
return {

    -- Mason (LSP installer)
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    -- Mason LSP Config
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPost",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "brymer-meneses/grammar-guard.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "rust_analyzer",
                    "clangd",
                    "vtsls",
                    "html",
                    "cssls",
                    "texlab",
                    "luau_lsp",
                    "emmet_ls",
--                    "ltex",
                    "efm",
                },
                automatic_installation = true,
            })


            -- LSP setups
            local lspconfig = require("lspconfig")
local languagetool = require("efmls-configs.linters.languagetool")
languagetool.lintCommand = "languagetool --language fr --json -  2>/tmp/languagetool_err.log"
-- local languagetool = {
--   lintCommand = "languagetool --language fr -  | grep -v WARNING"
-- ",
--   lintStdin = true,
--   lintFormats = { "%m" },
--   lintIgnoreExitCode = true,

local function on_attach(client, bufnr)
  if client.supports_method("textDocument/publishDiagnostics") then
    print("LanguageTool attached for buffer " .. bufnr)
  end
end

lspconfig.efm.setup({
  on_attach = on_attach,
  init_options = {
    documentFormatting = false,  -- LanguageTool does not support formatting
    documentRangeFormatting = false,
    hover = false,
    codeAction = false,
  },
  filetypes = { "text" },  -- only apply to .txt files
  settings = {
--    rootMarkers = { ".git/" },
    languages = {
      text = { languagetool },
    },
  },
})
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
})


            -- Try texlab first (usually more stable)
            local texlab_cmd = vim.fn.executable('texlab') == 1 and 'texlab' or nil
            local ltex_cmd = vim.fn.executable('ltex-ls') == 1 and 'ltex-ls' or nil

            if texlab_cmd then
                lspconfig.texlab.setup({
                    cmd = { texlab_cmd },
                    filetypes = { "tex", "plaintex", "bib" },
                })
            elseif ltex_cmd then
                -- lspconfig.ltex.setup({
                    --     cmd = { ltex_cmd },
                    --     filetypes = { "tex", "plaintex", "bib", "markdown" },
                    --     settings = {
                        --         ltex = {
                            --             language = "en-US",
                            --         }
                            --     }
                            -- })
                        else
                            vim.notify("No LaTeX LSP server found. Install texlab or ltex-ls", vim.log.levels.WARN)
                        end

                        lspconfig.vtsls.setup({
                            cmd = { "vtsls", "--stdio" },
                            filetypes = { "javascript", "typescript", "vue" },
                            root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
                            settings = {
                                typescript = {
                                    implicitProjectConfig = {
                                        checkJs = true,
                                    },
                                },
                                javascript = {
                                    implicitProjectConfig = {
                                        checkJs = true,
                                    },
                                },
                                vtsls = {
                                    experimental = {
                                        completion = {
                                            enableServerSideFuzzyMatch = true,
                                        },
                                    },
                                },
                            },
                        })

                        lspconfig.emmet_ls.setup({
                            filetypes = {
                                "html", "css", "typescriptreact", "javascriptreact", "jsx", "tsx",
                            },
                            init_options = {
                                html = {
                                    options = {
                                        ["bem.enabled"] = true,
                                    },
                                },
                            },
                        })

                        lspconfig.html.setup({
                            filetypes = { "htmldjango", "blade" },
                        })

                        -- Optional clangd fix
                        lspconfig.clangd.setup({
                            capabilities = {
                                offsetEncoding = { "utf-8" },
                            },
                        })

                        -- Lua config for Neovim runtime
                        lspconfig.lua_ls.setup({
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    end,
                },
            }





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
                    "pyright",
                    "vtsls",
                    "html",
                    "cssls",
                    "texlab",
                    "luau_lsp",
                    "emmet_ls",
                    "ltex_plus",
--                    "efm",
                },
                automatic_installation = true,
            })


            -- LSP setups
            local lspconfig = require("lspconfig")

-- lspconfig.harper_ls.setup{
-- --  cmd = { "harper_ls" },
--   filetypes = { "text","plaintext", "markdown", "tex" },  -- types de fichiers textes usuels pour correction
--   root_dir = lspconfig.util.root_pattern(".git", "."),
--   settings = {
--     language = "fr",  -- ou selon la clé que le serveur attend pour choisir la langue
--   },
--   on_attach = function(client, bufnr)
--     -- Optionnel : tu peux définir des raccourcis pour la correction ici
--   end,
-- }

lspconfig.ltex.setup{
  cmd = { "ltex-ls" },  -- chemin vers ltex-ls si pas dans PATH
  filetypes = { "tex", "markdown", "plaintext" }, -- fichiers texte à corriger
  settings = {
    ltex = {
      language = "fr",            -- forcer la langue française
      diagnosticSeverity = "information",
      enabled = { "fr" },         -- activer les règles françaises
      disabledRules = {},         -- liste des règles à désactiver si besoin
    },
  },
}






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


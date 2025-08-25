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
                    "ltex",
                },
                automatic_installation = true,
            })


            -- LSP setups
            local lspconfig = require("lspconfig")


            require("lspconfig").ltex.setup({
                 cmd = {vim.fn.expand("~/.local/share/ltex-ls/bin/ltex-ls")} ,
                settings = {
                    ltex = {
                        language = "fr",
                        dictionary = {
                            ["fr"] = { "exemple", "grammaire" }, -- add your custom words here
                        },
                        disabledRules = {
                            ["fr"] = { "OXFORD_SPELLING_Z_NOT_S" },
                        },
                    },
                },
                filetypes = { "tex", "latex", "markdown" },
            })


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


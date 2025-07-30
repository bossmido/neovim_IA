return {
    "saghen/blink.cmp",
    version = "v1.2.0",
    event = "InsertEnter",
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
        },
        {
            "giuxtaposition/blink-cmp-copilot",
        },
        {
            "neovim/nvim-lspconfig", -- Add if not already installed
        },
    },
    opts = function()
        -- Setup clangd via lspconfig
        local lspconfig = require("lspconfig")


        lspconfig.clangd.setup {
            cmd = { "clangd", "--offset-encoding=utf-8" },
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        }
        lspconfig.rust_analyzer.setup {
            settings = {
                ["rust-analyzer"] = {

                    cargo = { allFeatures = true },
                    checkOnSave = {
                        command = "clippy",

                    },

                },
            },
        }
        return {
            keymap = {
                ["<CR>"] = { "accept", "fallback" },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,
                    treesitter_highlighting = true,
                },
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
            },
            signature = { enabled = true },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
                per_filetype = {
                    codecompanion = { "codecompanion" },
                    cpp = { "lsp", "snippets", "path", "copilot" }, -- Optional per-language config
                    c = { "lsp", "snippets", "path", "copilot" },
                },
            },
        }
    end,
    opts_extend = { "sources.default" },
}


return {
    "saghen/blink.cmp",
    dependencies = { "Saghen/blink.compat", "rafamadriz/friendly-snippets",
        {
             "giuxtaposition/blink-cmp-copilot",
                config = function()
                    require("copilot").setup({
                        panel = {
                            enabled = true,
                            auto_refresh = true,
                            keymap = {
                                jump_prev = "[[",
                                jump_next = "]]",
                                accept = "<CR>",
                                refresh = "gr",
                                open = "<M-CR>"
                            },
                            layout = {
                                position = "bottom", -- or "top"
                                ratio = 0.4
                            },
                        },
                        suggestion = {
                            enabled = true,
                            auto_trigger = true,

                            debounce = 75,
                            keymap = {
                                accept = "<C-l>",
                                next = "<C-n>",
                                prev = "<C-p>",
                                dismiss = "<C-]>",
                            },
                        },
                        filetypes = {

                            markdown = true,
                            help = true,
                            gitcommit = true,
                            -- Disable for large files or unwanted types
                            yaml = false,
                        },
                        copilot_node_command = "node", -- adjust if using nvm or custom node
                        server_opts_overrides = {},
                    })
                end ,
            dependencies ="zbirenbaum/copilot.lua"
        },
        "neovim/nvim-lspconfig", -- Add if not already installed
    },

    opts = {

        -- snippets = {
        --     expand = function(snippet, _)
        --         return LazyVim.cmp.expand(snippet)
        --     end,
        -- },
        appearance = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = true,
            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",

        },

        completion = {
            accept = {
                -- experimental auto-brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = vim.g.ai_cmp,
            },
        },

        -- experimental signature help support
        -- signature = { enabled = true },

        sources = {
            -- adding any nvim-cmp sources here will enable them
            -- with blink.compat
            default = { "lsp", "path", "snippets", "buffer","copilot" },
        },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                score_offset = 100,
                async = true,

            }
        },
        cmdline = {
            enabled = false,
        },

        keymap = {
            preset = "enter",
            ["<TAB>"] = { "select_and_accept" },

        },

    },
    opts_extend = { "sources.default", "sources.compat" },
}

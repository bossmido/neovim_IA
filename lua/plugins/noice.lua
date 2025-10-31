return

{
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,

                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                    },
                },
                hover = {
                    enabled = true,
                },

            },
            presets = {
                bottom_search = true,         -- Use classic bottom cmdline for `/` and `?`
                command_palette = true,       -- Position command palette at top
                long_message_to_split = true, -- Long messages go to split view
                inc_rename = false,           -- Enable with `inc-rename.nvim`
                lsp_doc_border = true,        -- Add border to hover/docs
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "DiagnosticInfo",
                        },
                    },
                },
            },
        })

        -- Optional: set noice as the message handler
        vim.notify = require("notify")

        cmdline = {
            enabled = true,         -- enables the Noice cmdline UI
            view = "cmdline_popup", -- view for rendering the cmdline. Change to "cmdline" to get a classic cmdline at the bottom
            opts = {},              -- global options for the cmdline. See section on views
            format = {
                -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                -- view: (default is cmdline view)
                -- opts: any options passed to the view
                -- icon_hl_group: optional hl_group for the icon
                -- title: set to anything or empty string to hide
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
                git = { pattern = "^:%s*Git%s+", icon = "", lang = "bash", title = "Git" },
                -- lua = false, -- to disable a format, set to `false`
            }
        }
    end,
    routes = {
        {
            filter = { event = "msg_show", find = "deprecated" },
            opts = { skip = true }, -- ignore these messages
        },
    },
}

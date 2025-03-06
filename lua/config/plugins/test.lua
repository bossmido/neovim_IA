return {
    {
        -- dir = "~/plugins/present.nvim",
    },
    {
        'mfussenegger/nvim-lint',
        config = function()
            require('lint').linters_by_ft = {
                python = { 'mypy' },
            }

            vim.api.nvim_create_user_command("Lint", function()
                require("lint").try_lint()
            end, {})

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function() require("lint").try_lint() end,
            })
        end
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { '<leader>ss', '<cmd>SessionSearch<CR>',         desc = 'Session search' },
            { '<leader>sw', '<cmd>SessionSave<CR>',           desc = 'Save session' },
            { '<leader>sa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
        },
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            -- log_level = 'debug',
        }
    },
    {
        'mistweaverco/kulala.nvim',
        opts = {
            default_view = "headers_body",
            icons = {
                inlay = {
                    loading = "󱦟",
                    done = "",
                    error = "",
                },
                lualine = "🐼",
            },
        }
    },
    {
        'stevearc/quicker.nvim',
        event = "FileType qf",
        config = function()
            local quicker = require("quicker")

            vim.keymap.set("n", "<leader>q", function() quicker.toggle() end, { desc = "Toggle quickfix", })

            quicker.setup({
                keys = {
                    {
                        ">",
                        function() quicker.expand({ before = 2, after = 2, add_to_existing = true }) end,
                        desc = "Expand quickfix context",
                    },
                    {
                        "<",
                        function() quicker.collapse() end,
                        desc = "Collapse quickfix context",
                    },
                },
            })
        end
    },
    {
        "shellRaining/hlchunk.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                indent = {
                    enable = true,
                    -- use_treesitter = true,
                },
                chunk = {
                    enable = true,
                    style = "#eff222",
                    chars = {
                        horizontal_line = "─",
                        vertical_line = "│",
                        left_top = "┌",
                        left_bottom = "└",
                        right_arrow = "─",
                    },
                    duration = 0
                },
            })
        end
    },
    {
        "folke/trouble.nvim",
        enabled = false,
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}

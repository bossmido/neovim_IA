return {
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- signs = false
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local hooks = require "ibl.hooks"

            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                -- vim.api.nvim_set_hl(0, "IblIndent", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "IblScope", { fg = "#E5C07B" })
            end)

            require("ibl").setup {
                debounce = 100,
                indent = {
                    char = "│"
                },
                whitespace = {
                    remove_blankline_trail = false,
                },
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                },
            }
        end
    },
}

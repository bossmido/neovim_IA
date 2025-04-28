return {
    { "folke/tokyonight.nvim" },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("kanagawa").setup({
                theme = "wave",
                background = {
                    dark = "wave",
                    light = "lotus"
                },
                overrides = function(_)
                    return {
                        WinSeparator = { fg = "#e5c07b", bg = "none" }
                    }
                end,
                colors = {
                    -- NOTE: Palette colors:
                    -- https://github.com/rebelot/kanagawa.nvim/blob/master/lua/kanagawa/colors.lua
                    palette = {
                        -- sumiInk0 = "#fc0303", -- mode text
                        -- sumiInk1 = "#fc0303", -- dont know
                        -- sumiInk2 = "#fc0303", -- dont know
                        sumiInk3 = "#181818", -- background
                        sumiInk4 = "#2f2f2f", -- gutter
                        -- sumiInk5 = "#fc0303", -- select in telescope
                        sumiInk6 = "#5d5d5d", -- line numbers
                    },
                    -- NOTE: Themes:
                    -- https://github.com/rebelot/kanagawa.nvim/blob/master/lua/kanagawa/themes.lua
                    theme = {
                        wave = {
                            ui = {
                                bg_gutter = "#262626",
                                bg        = "#181818",
                                bg_p1     = "#262626",
                                bg_visual = "#2f2f2f",
                            },
                        },
                    },
                }
            })

            vim.cmd.colorscheme "kanagawa"
            -- vim.opt.fillchars:append({ vert = '┃' })
        end
    },
}

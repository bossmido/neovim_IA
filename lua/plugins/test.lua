return {
        'MeanderingProgrammer/render-markdown.nvim',
        -- enabled = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require("render-markdown").setup({
                enabled = false,
                anti_conceal = {
                    enabled = true,
                }
            })
        end
    }

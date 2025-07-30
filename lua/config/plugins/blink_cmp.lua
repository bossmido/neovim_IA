---@module "lazy"
---@type LazySpec
return {
    'saghen/blink.cmp',
    dependencies = { {
        'saghen/blink.compat',
        -- use v2.* for blink.cmp v1.*
        version = '2.*',
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    }, 'yetone/avante.nvim', 'rafamadriz/friendly-snippets', { "folke/lazydev.nvim", opts = {}, },
        'giuxtaposition/blink-cmp-copilot', 'Kaiser-Yang/blink-cmp-avante', },
    version = '*',
    opts = {
        keymap = {
            ["<CR>"] = { "accept", "fallback" },
        },
        completion = {
            accept = { auto_brackets = { enabled = true } },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                treesitter_highlighting = true,
                window = { border = "rounded" },

            },
        },
        list = {
            selection = function(ctx)
                return ctx.mode == "cmdline" and "auto_insert" or "preselect"
            end,
        },
        signature = { enabled = true },
        sources = {
            default = { "avante", "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                },
                avante = {
                    module = 'blink-cmp-avante',
                    name = 'Avante',
                    opts = {
                        -- options for blink-cmp-avante

                    }
                },
            },
            per_filetype = {
                codecompanion = { "codecompanion" },
            },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'normal',
        },


    },

    event = { 'InsertEnter', 'CmdlineEnter' },


    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    -- My super-TAB configuration
    keymap = {

        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },

        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {
            function(cmp)
                return cmp.select_next()
            end,
            'snippet_forward',
            'fallback',
        },
        ['<S-Tab>'] = {
            function(cmp)
                return cmp.select_prev()
            end,
            'snippet_backward',
            'fallback',
        },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },

        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },

        ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
    },

    -- Experimental signature help support
    signature = {
        enabled = true,
        window = { border = 'rounded' },
    },


    sources = {
        default = { 'avante', 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',

                -- Make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
            lsp = {

                min_keyword_length = 2, -- Number of characters to trigger provider
                score_offset = 0,       -- Boost/penalize the score of the items
            },
            path = {

                min_keyword_length = 0,
            },
            snippets = {
                min_keyword_length = 2,

            },
            buffer = {
                min_keyword_length = 4,
                max_items = 5,
            },
        },
    },
}

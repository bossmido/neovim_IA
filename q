return {
    "Saghen/blink.cmp",

    event = "InsertEnter",
    dependencies = {
        "L3MON4D3/LuaSnip",

        "rafamadriz/friendly-snippets",
        -- External sources (Blink-compatible or wrapped)
        "zbirenbaum/copilot.lua",         -- For Copilot
        "zbirenbaum/copilot-cmp",         -- Needed for blink-cmp-copilot adapter
        "jmbuhr/otter.nvim",              -- Otter
        "micangl/cmp-vimtex",             -- VimTeX source (we’ll adapt it)

        "p00f/clangd_extensions.nvim",    -- For clangd score sorting
    },

    opts = function()
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        return {
            completion = {
                accept = { select = true },
                documentation = { auto_show = true },
                menu = {

                    auto_show = true,
                    border = "rounded",
                },
                ghost_text = true,
                keyword_length = 2,

            },

            keymap = {
                ["<C-Space>"] = "show",
                ["<C-e>"] = "cancel",
                ["<CR>"] = { "accept", select = true },
                ["<Up>"] = "select_prev",
                ["<Down>"] = "select_next",
                ["<Tab>"] = { "snippet_forward", "select_next" },
                ["<S-Tab>"] = { "snippet_backward", "select_prev" },
                ["<C-b>"] = "scroll_documentation_up",
                ["<C-f>"] = "scroll_documentation_down",

            },

            snippets = {
                expand = function(args)
                    local ok_otter, otter = pcall(require, "otter")
                    if ok_otter and otter.expand then
                        otter.expand(args.body)
                    end
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = {
                default = {

                    "lsp",
                    "path",
                    "buffer",
                    "snippets",
                    "calc",
                    "copilot",

                    "otter",
                    "vimtex",
                },

                providers = {
                    copilot = {
                        module = "blink-cmp-copilot",
                        name = "copilot",
                        score_offset = 50, -- Give AI suggestions higher priority
                    },
                    otter = {
                        module = "blink-cmp-otter",
                        name = "otter",
                        score_offset = 20,
                    },
                    vimtex = {
                        module = "blink-cmp-vimtex",
                        name = "vimtex",
                        score_offset = 10,
                    },
                },
            },


            filtering = {
                enable = function(ctx)
                    local ts_utils = require("nvim-treesitter.ts_utils")
                    local ft = vim.bo.filetype
                    if ft == "html" then
                        local node = ts_utils.get_node_at_cursor()
                        while node do
                            if node:type() == "text" then
                                return false
                            end
                            node = node:parent()
                        end
                    end


                    -- disable in comments
                    return not ctx.in_comment
                end,
            },


            formatting = {

                fields = { "kind_icon", "abbr", "menu" },
                kind_icons = true, -- uses built-in icons
                format = function(entry, item)
                    local menu_map = {
                        lsp = "[LSP]",
                        snippets = "[Snip]",
                        buffer = "[Buf]",
                        copilot = "[Cop]",
                        path = "[Path]",
                        otter = "[Otter]",

                        vimtex = "[Tex]",
                        calc = "[Calc]",
                    }
                    item.menu = menu_map[entry.source.name] or ""
                    return item
                end,
            },

            sorting = {
                priority = {
                    "exact",
                    "score",

                    "recency",
                    "length",
                },
            },
        }

    end,

    config = function(_, opts)
        -- Optional: load copilot if available
        local ok, copilot = pcall(require, "copilot")
        if ok then
            copilot.setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
            require("copilot_cmp").setup()
        end
        -- Setup blink.cmp
        require("blink.cmp").setup(opts)
    end,

}


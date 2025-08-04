return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "VimEnter",
    keys = { "<Tab>", "<S-Tab>", "<C-Space>" },
    version = false,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-emoji",
        "KadoBOT/cmp-plugins",
        "hrsh7th/cmp-calc",
        "zbirenbaum/cmp-copilot",
        "jmbuhr/otter.nvim",
    },
    opts = {
        formatting = function()
            local lspkind = require("lspkind")
            local formatting_var = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    menu = {
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snip]",
                        buffer = "[Buf]",
                        copilot = "[Cop]",
                        plugins = "[Plug]",
                        path = "[Path]",
                    },
                    maxwidth = 90,
                    ellipsis_char = "...",
                }),
            }
            return formatting_var
            --require("cmp").setup(opts)
        end,
        snippet = {
            expand = function(args)
                require("otter").expand(args.body)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        sources = {
            { name = "otter" },
            { name = "calc" },
            { name = "copilot", group_index = 2, keyword_length = 3 },
            { name = "lazydev" },
            { name = "nvim_lsp" },
            { name = "codecompanion" },
            { name = "luasnip" },
            { name = "path" },
            { name = "plugins" },
            { name = "buffer" },
        },
        preselect = require("cmp").PreselectMode.None,
        completion = {
            completeopt = "menu,menuone,noinsert",
        },
        experimental = {
            hl_group = "CmpGhostText",
        },
        mapping = require("cmp").mapping.preset.insert({
            ["<Up>"] = require("cmp").mapping.select_prev_item(),
            ["<Down>"] = require("cmp").mapping.select_next_item(),
            ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
            ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
            ["<C-Space>"] = require("cmp").mapping.complete(),
            ["<C-e>"] = require("cmp").mapping.abort(),
            ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
            ["<Tab>"] = function(fallback)
                local cmp = require("cmp")
                local luasnip = require("luasnip")
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif require("otter").expand_or_jumpable() then
                    require("otter").expand_or_jump()
                else
                    fallback()
                end
            end,
            ["<S-Tab>"] = function(fallback)
                local cmp = require("cmp")
                local luasnip = require("luasnip")
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
        }),
    },
    config = function(_, opts)
        local lspkind = require("lspkind")
        opts.formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                menu = {
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snip]",
                    buffer = "[Buf]",
                    copilot = "[Cop]",
                    plugins = "[Plug]",
                    path = "[Path]",
                },
                maxwidth = 90,
                ellipsis_char = "...",
            }),
        }
        require("cmp").setup(opts)
    end,
}

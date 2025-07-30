-- in your lazy spec file (e.g. lua/plugins.lua or lazy.lua)

return {


    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    version = false, -- use latest commit

    dependencies = {

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        -- add more sources if needed, e.g.:
        "hrsh7th/cmp-cmdline", "onsails/lspkind.nvim"
    , "hrsh7th/cmp-emoji"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            -- mapping = cmp.mapping.preset.insert({
            --     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            --     ["<C-f>"] = cmp.mapping.scroll_docs(4),
            --     ["<C-Space>"] = cmp.mapping.complete(),
            --     ["<C-e>"] = cmp.mapping.abort(),
            --     ["<CR>"] = cmp.mapping.confirm({ select = true }),
            --     ["<Tab>"] = cmp.mapping(function(fallback)
            --         if cmp.visible() then
            --             cmp.select_next_item()
            --         elseif luasnip.expand_or_jumpable() then
            --             luasnip.expand_or_jump()
            --         else
            --             fallback()
            --         end
            --     end, { "i", "s" }),
            --     ["<S-Tab>"] = cmp.mapping(function(fallback)
            --         if cmp.visible() then
            --             cmp.select_prev_item()
            --         elseif luasnip.jumpable(-1) then
            --             luasnip.jump(-1)
            --         else
            --             fallback()
            --         end
            --     end, { "i", "s" }),
            -- }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },

            }, {
                { name = "buffer" },
            }),
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",

                    menu = {

                        nvim_lsp = "[LSP]",
                        luasnip  = "[Snip]",
                        buffer   = "[Buf]",

                        path     = "[Path]",

                    },
                }),
            },
            --     window = {
            --         completion = cmp.config.window.bordered(),
            --         documentation = cmp.config.window.bordered(),
            --     },
        })


        -- Optional: buffer and cmdline completions

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        })
    end,
    opts = function(_, opts)
        --        table.insert(opts.sources, { name = "emoji" })
    end,
    mapping = require("cmp").mapping.preset.insert({
        ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
        ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-Space>"] = require("cmp").mapping.complete(),
        ["<C-e>"] = require("cmp").mapping.abort(),
        ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
        ["<Tab>"] = require("cmp").mapping(function(fallback)
            if require("cmp").visible() then
                require("cmp").select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = require("cmp").mapping(function(fallback)
            if require("cmp").visible() then
                require("cmp").select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    })

}

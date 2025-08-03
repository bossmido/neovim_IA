-- in your lazy spec file (e.g. lua/plugins.lua or lazy.lua

return {


    "hrsh7th/nvim-cmp",
    lazy=true,
      event = "VeryLazy",
    --keys = { "<Tab>", "<S-Tab>", "<C-Space>", "<Up>", "<Down>", "<Left>", "<Right>" },
    version = false, -- use latest commit

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
        "L3MON4D3/LuaSnip"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('otter').expand(args.body)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = cmp.config.sources({
                {name="calc"},
                { name = "copilot",      group_index = 2, keyword_length = 3 },
                {name="lazydev"},
                { name = "nvim_lsp" },
                { name = "codecompanion" },
                { name = "luasnip" },
                { name = "path" },
                { name = 'plugins' },
                { name = "buffer" }, providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.cmp",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            }),
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",

                    menu = {

                        nvim_lsp = "[LSP]",
                        luasnip  = "[Snip]",
                        buffer   = "[Buf]",
                        copilot  = "[Cop]",
                        plugins  = "[plug]",
                        path     = "[Path]",

                    },
                    maxwidth = 80,

                    ellipsis_char = "...",
                }),
            },
            --     window = {
                --         completion = cmp.config.window.bordered(),
                --         documentation = cmp.config.window.bordered(),
                --     },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                experimental = {
                    --ghost_text = true,
                    hl_group = "CmpGhostText", -- Highlight group for ghost text
                },
                -- ↓↓↓↓↓ this is the important part ↓↓↓↓↓
                preselect = cmp.PreselectMode.None,
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                -- 👇 Filter Copilot entries if prefix length < 3
                -- You can also filter by content, etc.
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "near_cursor",
                    },
                },
                -- this is what filters them based on input length
                -- (copilot provides suggestions even for short input, so we filter them out manually)
                entry_filter = function(entry, ctx)
                    local source_name = entry.source.name
                    local filetype = vim.bo.filetype

                    -- Filetypes with no restrictions
                    local allow_all_filetypes = {
                        html = true,
                        css = true,
                        scss = true,
                        sass = true,
                        less = true,
                        json = true,
                        yaml = true,
                        toml = true,
                        ini = true,
                        xml = true,
                        vue = true,
                    }

                    if allow_all_filetypes[filetype] then
                        return true
                    end

                    -- buffer only in comments
                    if source_name == "buffer" then
                        local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
                        if not ok then return true end

                        local node = ts_utils.get_node_at_cursor()
                        while node do
                            if node:type() == "comment" then
                                return true
                            end
                            node = node:parent()
                        end
                        return false
                    end

                    -- Copilot requires at least 4 chars
                    if source_name == "copilot" and #ctx.cursor_before_line < 4 then
                        return false
                    end

                    -- Other sources only in functions, methods, classes, or objects
                    local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
                    if not ok then return true end

                    local node = ts_utils.get_node_at_cursor()
                    while node do
                        local type = node:type()
                        if type == "function"
                            or type == "function_definition"
                            or type == "method_definition"
                            or type == "method"
                            or type == "class"
                            or type == "class_definition"
                            or type == "object"
                            or type == "object_literal"
                            or type == "table_constructor"
                            then
                                return true
                            end
                            node = node:parent()
                        end

                        return false
                    end,
                })


                -- Optional: buffer and cmdline completions

                cmp.setup.cmdline({ "/", "?" }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = { { name = "buffer" } },
                })

                cmp.setup.cmdline(':', {
                    -- mapping = {
                        --     ['<CR>'] = function(fallback)
                            --         if cmp.visible() then
                            --             -- Select the first item if nothing is selected
                            --             cmp.confirm({ select = true })
                            --         else
                            --             fallback()
                            --         end
                            --     end
                            -- },
                            sources = cmp.config.sources({
                                { name = 'path' }
                                -- }, 
                                -- {  { name = 'cmdline' }
                            })
                        })
                    end,
                    -- opts = function(_, opts)
                        --     table.insert(opts.sources, { name = "emoji" })
                        -- end,
                        mapping = require("cmp").mapping.preset.insert({
                            ["<Up>"] = require('cmp').mapping.select_prev_item(),
                            ["<Down>"] = require('cmp').mapping.select_next_item(),
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
                                elseif require('otter').expand_or_jumpable() then
                                    require('otter').expand_or_jump()

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
                            end)

                        })
                    }

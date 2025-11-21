return {
    "hrsh7th/nvim-cmp",
    enabled=true,
    ---cond = function()
    --return vim.bo.filetype == "Avante" or vim.g.avante_active
  --end,
    lazy = false,
    event = "VimEnter",
    keys = { "<C-Space>","<Tab>", "<S-Tab>", "<C-Space>" },
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
--        "KadoBOT/cmp-plugins",
        "hrsh7th/cmp-calc",
        "zbirenbaum/cmp-copilot",
        "micangl/cmp-vimtex",
        "jmbuhr/otter.nvim",
        "p00f/clangd_extensions.nvim"
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
                local otter= require("otter")
                if otter.expand ~=nil then
                    otter.expand(args.body)
                end 
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
            { name = "buffer", keyword_length = 1000  },
            { name="vimtex"}
        },
        preselect = require("cmp").PreselectMode.None,
        completion = {
            completeopt = "menu,menuone,noinsert",
            enabled = function()
                local ts_utils = require("nvim-treesitter.ts_utils")
                local filetype = vim.api.nvim_buf_get_option(0, "filetype")
                if filetype == "html" then
                    local node = ts_utils.get_node_at_cursor()
                    while node do
                        local type = node:type()
                        if type == "text" then
                            return false  -- Disable in raw text nodes
                        end
                        node = node:parent()
                    end
                end




                local context = require('cmp.config.context')
                -- Disable completion in comments
                if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
                    return false
                end
                return true
            end,
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
                local luasnip_ok, luasnip = pcall(require, "luasnip")
                local otter_ok, otter = pcall(require, "otter")
                local tabout_ok, tabout = pcall(require, "tabout")

                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif luasnip_ok and luasnip.expand_or_jumpable and luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif otter_ok and otter.expand_or_jumpable and otter.expand_or_jumpable() then
                    otter.expand_or_jump()
                elseif tabout_ok and tabout.tabout and tabout.tabout() then
                    return
                else
                    -- Manually trigger buffer completion
                    cmp.complete({ config = { sources = { { name = "buffer" } } } })
                end
            end,

            ["<S-Tab>"] = function(fallback)
                local cmp = require("cmp")
                local luasnip_ok, luasnip = pcall(require, "luasnip")
                local otter_ok, otter = pcall(require, "otter")
                local tabout_ok, tabout = pcall(require, "tabout")

                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip_ok and luasnip.jumpable and luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                elseif otter_ok and otter.jumpable and otter.jumpable(-1) then
                    otter.jump(-1)
                elseif tabout_ok and tabout.tabout and tabout.tabout(true) then
                    return
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
        sorting = {
        comparators = {
            require("cmp").config.compare.offset,

            require("cmp").config.compare.exact,
            require("cmp").config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            require("cmp").config.compare.kind,

            require("cmp").config.compare.sort_text,
            require("cmp").config.compare.length,
            require("cmp").config.compare.order,
        },
    }
    end,
}



--   'hrsh7th/nvim-cmp',
--   dependencies = {
--     'L3MON4D3/LuaSnip',
--     'saadparwaiz1/cmp_luasnip',
--     'rafamadriz/friendly-snippets', -- optional but recommended
--   }
--   ,setup = function()
--       require("luasnip.loaders.from_vscode").lazy_load()
--   end,
-- }
--
--
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  },
  event = 'InsertEnter', -- lazy-load on first insert mode usage
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    -- Load snippets lazily
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end
}

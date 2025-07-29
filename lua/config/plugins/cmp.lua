-- Required plugins
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets', -- optional but recommended
  }
  ,setup = function()
      require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

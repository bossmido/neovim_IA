return {
  "nvim-tree/nvim-tree.lua",
  version = "*", -- optional: lock to latest stable release
  lazy = false,  -- or `event = "VeryLazy"` to defer load
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })
  end,
}

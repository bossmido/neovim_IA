return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "InsertEnter", "BufReadPost" },  -- load when editing starts or buffer loaded
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}


return {
  "nvim-telescope/telescope-frecency.nvim",
  -- install the latest stable version
  cmd="Telescope",
  version = "*",
  config = function()
    require("telescope").load_extension "frecency"
  end,
}

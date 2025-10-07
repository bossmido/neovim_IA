return {
  "nvim-telescope/telescope-frecency.nvim",
  version = "*",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<C-f>",
      function()
        require("telescope").extensions.frecency.frecency()
      end,
      desc = "Frecency search (Telescope)",
    },
    {
      "<C-g>",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep (Telescope)",
    },
  },
  config = function()
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("frecency")
    end
  end,
}


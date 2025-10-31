return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
        require("lspsaga").setup({  lightbulb = {
    enable = true,
    sign = true,
    enable_in_insert = false,
  },})
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional but recommended
        "nvim-tree/nvim-web-devicons", -- for icons
    },
}

return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
        require("lspsaga").setup({})
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional but recommended
        "nvim-tree/nvim-web-devicons", -- for icons
    },
}

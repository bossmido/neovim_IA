return {
    "nvim-neotest/neotest",
    key="F8",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "alfaix/neotest-gtest",
        "rouge8/neotest-rust",
        "nvim-neotest/neotest-python",
        "olimorris/neotest-phpunit"
    },config = function()
        require("neotest").setup({})
        vim.keymap.set({'n','i'}, '<F8>', function()

              require("neotest").run.run(vim.fn.expand("%"))
        end, { desc = "Run nearest test with neotest" })
    end
}
